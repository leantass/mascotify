import type {
  QrLocationSource,
  QrPetStatus,
  QrScanStatus
} from '@prisma/client';

export type QrRegisteredPetRecord = {
  id: string;
  qrId: string;
  petId: string;
  ownerUserId: string;
  publicName: string;
  species: string;
  breed: string | null;
  color: string | null;
  publicNotes: string | null;
  status: QrPetStatus;
  createdAt: Date;
  updatedAt: Date;
};

export type QrScanEventRecord = {
  id: string;
  qrId: string;
  registeredPetId: string;
  ownerUserId: string;
  scannedAt: Date;
  locationSource: QrLocationSource;
  latitude: number | null;
  longitude: number | null;
  accuracyMeters: number | null;
  country: string | null;
  region: string | null;
  city: string | null;
  area: string | null;
  message: string | null;
  scannerContact: string | null;
  safetyFlag: boolean;
  readAt: Date | null;
  status: QrScanStatus;
  fingerprint: string;
  registeredPet?: QrRegisteredPetRecord;
};

export type RegisterQrPetInput = {
  qrId?: unknown;
  petId?: unknown;
  publicName?: unknown;
  species?: unknown;
  breed?: unknown;
  color?: unknown;
  publicNotes?: unknown;
  status?: unknown;
};

export type CreateQrScanInput = {
  locationSource?: unknown;
  latitude?: unknown;
  longitude?: unknown;
  accuracyMeters?: unknown;
  country?: unknown;
  region?: unknown;
  city?: unknown;
  area?: unknown;
  message?: unknown;
  scannerContact?: unknown;
};

export type NormalizedQrPetInput = {
  qrId: string;
  petId: string;
  ownerUserId: string;
  publicName: string;
  species: string;
  breed: string | null;
  color: string | null;
  publicNotes: string | null;
  status: QrPetStatus;
};

export type NormalizedQrScanInput = {
  qrId: string;
  registeredPetId: string;
  ownerUserId: string;
  locationSource: QrLocationSource;
  latitude: number | null;
  longitude: number | null;
  accuracyMeters: number | null;
  country: string | null;
  region: string | null;
  city: string | null;
  area: string | null;
  message: string | null;
  scannerContact: string | null;
  safetyFlag: boolean;
  fingerprint: string;
};

export type PublicQrPetResponse = {
  qrId: string;
  petId: string;
  publicName: string;
  species: string;
  breed: string | null;
  color: string | null;
  publicNotes: string | null;
  status: QrPetStatus;
};

export type QrScanEventResponse = {
  id: string;
  qrId: string;
  petId: string;
  ownerUserId: string;
  scannedAt: string;
  locationSource: QrLocationSource;
  latitude: number | null;
  longitude: number | null;
  accuracyMeters: number | null;
  country: string | null;
  region: string | null;
  city: string | null;
  area: string | null;
  message: string | null;
  scannerContact: string | null;
  safetyFlag: boolean;
  readAt: string | null;
  status: QrScanStatus;
  possibleLostPetSighting: boolean;
  publicPet: PublicQrPetResponse;
};

export type QrRepositoryPort = {
  upsertRegisteredPet(
    input: NormalizedQrPetInput
  ): Promise<QrRegisteredPetRecord>;
  findRegisteredPetByQrId(qrId: string): Promise<QrRegisteredPetRecord | null>;
  createScanEvent(input: NormalizedQrScanInput): Promise<QrScanEventRecord>;
  findRecentDuplicateScan(input: {
    qrId: string;
    fingerprint: string;
    since: Date;
  }): Promise<QrScanEventRecord | null>;
  listOwnerScans(input: {
    ownerUserId: string;
    unreadOnly: boolean;
  }): Promise<QrScanEventRecord[]>;
  markOwnerScanRead(input: {
    ownerUserId: string;
    scanId: string;
  }): Promise<QrScanEventRecord | null>;
};
