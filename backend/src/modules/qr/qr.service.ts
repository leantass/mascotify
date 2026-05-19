import {
  QrLocationSource,
  QrPetStatus
} from '@prisma/client';

import { PrismaQrRepository } from './qr.repository';
import type {
  CreateQrScanInput,
  NormalizedQrPetInput,
  NormalizedQrScanInput,
  PublicQrPetResponse,
  QrRegisteredPetRecord,
  QrRepositoryPort,
  QrScanEventRecord,
  QrScanEventResponse,
  RegisterQrPetInput
} from './qr.types';

const DUPLICATE_WINDOW_MS = 20_000;

export class QrError extends Error {
  constructor(
    readonly statusCode: number,
    readonly code: string,
    message: string,
    readonly details: Array<{ field: string; message: string }> = []
  ) {
    super(message);
  }
}

export class QrService {
  constructor(
    private readonly repository: QrRepositoryPort = new PrismaQrRepository()
  ) {}

  async registerPet(
    ownerUserId: string,
    input: RegisterQrPetInput
  ): Promise<{ pet: PublicQrPetResponse; ownerUserId: string }> {
    const normalized = normalizePetInput(ownerUserId, input);
    const pet = await this.repository.upsertRegisteredPet(normalized);

    return { pet: toPublicPet(pet), ownerUserId: pet.ownerUserId };
  }

  async getPublicPet(qrId: string): Promise<PublicQrPetResponse> {
    const pet = await this.findPetOrThrow(qrId);
    return toPublicPet(pet);
  }

  async createPublicScan(
    qrId: string,
    input: CreateQrScanInput
  ): Promise<QrScanEventResponse> {
    const pet = await this.findPetOrThrow(qrId);
    const normalized = normalizeScanInput(pet, input);

    if (normalized.safetyFlag) {
      throw new QrError(
        400,
        'PAYMENT_INTENT_BLOCKED',
        'Mascotify no permite pedir dinero por una mascota encontrada. Modifica el texto para continuar.',
        [{ field: 'message', message: 'Payment intent is not allowed.' }]
      );
    }

    const duplicate = await this.repository.findRecentDuplicateScan({
      qrId: pet.qrId,
      fingerprint: normalized.fingerprint,
      since: new Date(Date.now() - DUPLICATE_WINDOW_MS)
    });

    if (duplicate) {
      return toScanResponse(duplicate);
    }

    const scan = await this.repository.createScanEvent(normalized);
    return toScanResponse(scan);
  }

  async listOwnerScans(input: {
    ownerUserId: string;
    unreadOnly?: boolean;
  }): Promise<QrScanEventResponse[]> {
    const ownerUserId = normalizeRequiredText(input.ownerUserId, 'ownerUserId');
    const scans = await this.repository.listOwnerScans({
      ownerUserId,
      unreadOnly: Boolean(input.unreadOnly)
    });

    return scans.map(toScanResponse);
  }

  async markOwnerScanRead(
    ownerUserId: string,
    scanId: string
  ): Promise<QrScanEventResponse> {
    const scan = await this.repository.markOwnerScanRead({
      ownerUserId: normalizeRequiredText(ownerUserId, 'ownerUserId'),
      scanId: normalizeRequiredText(scanId, 'scanId')
    });

    if (!scan) {
      throw new QrError(404, 'NOT_FOUND', 'QR scan event not found.');
    }

    return toScanResponse(scan);
  }

  private async findPetOrThrow(qrId: string): Promise<QrRegisteredPetRecord> {
    const normalizedQrId = normalizeRequiredText(qrId, 'qrId');
    const pet = await this.repository.findRegisteredPetByQrId(normalizedQrId);

    if (!pet) {
      throw new QrError(404, 'NOT_FOUND', 'QR pet not found.');
    }

    return pet;
  }
}

function normalizePetInput(
  ownerUserId: string,
  input: RegisterQrPetInput
): NormalizedQrPetInput {
  return {
    ownerUserId: normalizeRequiredText(ownerUserId, 'ownerUserId'),
    qrId: normalizeRequiredText(input.qrId, 'qrId'),
    petId: normalizeRequiredText(input.petId, 'petId'),
    publicName: normalizeRequiredText(input.publicName, 'publicName'),
    species: normalizeRequiredText(input.species, 'species'),
    breed: normalizeNullableText(input.breed),
    color: normalizeNullableText(input.color),
    publicNotes: normalizeNullableText(input.publicNotes),
    status: normalizePetStatus(input.status)
  };
}

function normalizeScanInput(
  pet: QrRegisteredPetRecord,
  input: CreateQrScanInput
): NormalizedQrScanInput {
  const locationSource = normalizeLocationSource(input.locationSource);
  const latitude = normalizeOptionalNumber(input.latitude, 'latitude');
  const longitude = normalizeOptionalNumber(input.longitude, 'longitude');
  const accuracyMeters = normalizeOptionalNumber(
    input.accuracyMeters,
    'accuracyMeters'
  );
  const country = normalizeNullableText(input.country);
  const region = normalizeNullableText(input.region);
  const city = normalizeNullableText(input.city);
  const area = normalizeNullableText(input.area);
  const message = normalizeNullableText(input.message);
  const scannerContact = normalizeNullableText(input.scannerContact);
  const paymentText = [message, scannerContact].filter(Boolean).join(' ');
  const fingerprint = normalizeFingerprint([
    locationSource,
    latitude,
    longitude,
    country,
    region,
    city,
    area,
    message,
    scannerContact
  ]);

  if (
    locationSource === QrLocationSource.MANUAL &&
    !city &&
    !area &&
    !region
  ) {
    throw new QrError(
      400,
      'VALIDATION_ERROR',
      'Manual location requires city, region, or area.',
      [{ field: 'area', message: 'Location reference is required.' }]
    );
  }

  if (
    locationSource === QrLocationSource.DEVICE_GEOLOCATION &&
    (latitude == null || longitude == null)
  ) {
    throw new QrError(
      400,
      'VALIDATION_ERROR',
      'Device geolocation requires latitude and longitude.',
      [{ field: 'latitude', message: 'Latitude and longitude are required.' }]
    );
  }

  return {
    qrId: pet.qrId,
    registeredPetId: pet.id,
    ownerUserId: pet.ownerUserId,
    locationSource,
    latitude,
    longitude,
    accuracyMeters,
    country,
    region,
    city,
    area,
    message,
    scannerContact,
    safetyFlag: containsPaymentIntent(paymentText),
    fingerprint
  };
}

function normalizeRequiredText(value: unknown, field: string): string {
  if (typeof value !== 'string') {
    throw new QrError(400, 'VALIDATION_ERROR', 'QR data is invalid.', [
      { field, message: 'Must be a string.' }
    ]);
  }

  const normalized = value.trim();
  if (!normalized) {
    throw new QrError(400, 'VALIDATION_ERROR', 'QR data is invalid.', [
      { field, message: 'Required.' }
    ]);
  }

  return normalized;
}

function normalizeNullableText(value: unknown): string | null {
  if (value == null) return null;
  if (typeof value !== 'string') {
    throw new QrError(400, 'VALIDATION_ERROR', 'QR data is invalid.');
  }
  const normalized = value.trim();
  return normalized || null;
}

function normalizeOptionalNumber(value: unknown, field: string): number | null {
  if (value == null || value === '') return null;
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    throw new QrError(400, 'VALIDATION_ERROR', 'QR data is invalid.', [
      { field, message: 'Must be a finite number.' }
    ]);
  }
  return value;
}

function normalizePetStatus(value: unknown): QrPetStatus {
  if (value == null || value === '') return QrPetStatus.NORMAL;
  if (
    value === QrPetStatus.NORMAL ||
    value === QrPetStatus.LOST ||
    value === QrPetStatus.FOUND
  ) {
    return value;
  }
  throw new QrError(400, 'VALIDATION_ERROR', 'QR pet status is invalid.', [
    { field: 'status', message: 'Unsupported status.' }
  ]);
}

function normalizeLocationSource(value: unknown): QrLocationSource {
  if (value == null || value === '') return QrLocationSource.UNKNOWN;
  if (
    value === QrLocationSource.DEVICE_GEOLOCATION ||
    value === QrLocationSource.MANUAL ||
    value === QrLocationSource.UNKNOWN
  ) {
    return value;
  }
  throw new QrError(400, 'VALIDATION_ERROR', 'QR location source is invalid.', [
    { field: 'locationSource', message: 'Unsupported source.' }
  ]);
}

function containsPaymentIntent(text: string): boolean {
  const normalized = text.toLowerCase();
  return [
    'cobro',
    'cobrar',
    'pagame',
    'pago',
    'plata',
    'rescate',
    'recompensa obligatoria',
    'transferencia',
    'alias',
    'cbu',
    'mercado pago',
    'deposito',
    'depósito'
  ].some((term) => normalized.includes(term));
}

function normalizeFingerprint(values: unknown[]): string {
  return values
    .map((value) =>
      value == null ? '' : String(value).trim().toLowerCase().slice(0, 120)
    )
    .join('|');
}

function toPublicPet(pet: QrRegisteredPetRecord): PublicQrPetResponse {
  return {
    qrId: pet.qrId,
    petId: pet.petId,
    publicName: pet.publicName,
    species: pet.species,
    breed: pet.breed,
    color: pet.color,
    publicNotes: pet.publicNotes,
    status: pet.status
  };
}

function toScanResponse(scan: QrScanEventRecord): QrScanEventResponse {
  const publicPet = toPublicPet(scan.registeredPet!);

  return {
    id: scan.id,
    qrId: scan.qrId,
    petId: publicPet.petId,
    ownerUserId: scan.ownerUserId,
    scannedAt: scan.scannedAt.toISOString(),
    locationSource: scan.locationSource,
    latitude: scan.latitude,
    longitude: scan.longitude,
    accuracyMeters: scan.accuracyMeters,
    country: scan.country,
    region: scan.region,
    city: scan.city,
    area: scan.area,
    message: scan.message,
    scannerContact: scan.scannerContact,
    safetyFlag: scan.safetyFlag,
    readAt: scan.readAt?.toISOString() ?? null,
    status: scan.status,
    possibleLostPetSighting: publicPet.status === QrPetStatus.LOST,
    publicPet
  };
}
