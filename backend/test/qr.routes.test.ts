import assert from 'node:assert/strict';
import type { AddressInfo } from 'node:net';
import http from 'node:http';
import test from 'node:test';

import express from 'express';
import {
  QrLocationSource,
  QrPetStatus,
  QrScanStatus
} from '@prisma/client';

import { createQrRouter } from '../src/modules/qr/qr.routes';
import { QrService } from '../src/modules/qr/qr.service';
import type {
  NormalizedQrPetInput,
  NormalizedQrScanInput,
  QrRegisteredPetRecord,
  QrRepositoryPort,
  QrScanEventRecord
} from '../src/modules/qr/qr.types';

test('public QR endpoint does not expose owner private data', async () => {
  await withQrServer(async ({ baseUrl, repository }) => {
    await repository.upsertRegisteredPet(validPetInput());

    const response = await fetch(`${baseUrl}/api/v1/qr/public/MSC-QR-1`);
    const body = await response.json();

    assert.equal(response.status, 200);
    assert.equal(body.pet.publicName, 'Luna');
    assert.equal(body.pet.ownerUserId, undefined);
    assert.equal(body.pet.phone, undefined);
    assert.equal(body.pet.email, undefined);
    assert.equal(body.pet.address, undefined);
  });
});

test('public scan with device location creates an event', async () => {
  await withQrServer(async ({ baseUrl, repository }) => {
    await repository.upsertRegisteredPet(validPetInput());

    const response = await postJson(`${baseUrl}/api/v1/qr/public/MSC-QR-1/scans`, {
      locationSource: QrLocationSource.DEVICE_GEOLOCATION,
      latitude: -34.6037,
      longitude: -58.3816,
      accuracyMeters: 18,
      message: 'La vi en la esquina.'
    });
    const body = await response.json();

    assert.equal(response.status, 201);
    assert.equal(body.scan.latitude, -34.6037);
    assert.equal(body.scan.longitude, -58.3816);
    assert.equal(repository.scans.length, 1);
  });
});

test('public scan with manual location creates an event', async () => {
  await withQrServer(async ({ baseUrl, repository }) => {
    await repository.upsertRegisteredPet(validPetInput());

    const response = await postJson(`${baseUrl}/api/v1/qr/public/MSC-QR-1/scans`, {
      locationSource: QrLocationSource.MANUAL,
      country: 'Argentina',
      region: 'Buenos Aires',
      city: 'CABA',
      area: 'Parque Chacabuco'
    });
    const body = await response.json();

    assert.equal(response.status, 201);
    assert.equal(body.scan.city, 'CABA');
    assert.equal(body.scan.area, 'Parque Chacabuco');
  });
});

test('public scan with payment intent is blocked', async () => {
  await withQrServer(async ({ baseUrl, repository }) => {
    await repository.upsertRegisteredPet(validPetInput());

    const response = await postJson(`${baseUrl}/api/v1/qr/public/MSC-QR-1/scans`, {
      locationSource: QrLocationSource.MANUAL,
      city: 'CABA',
      message: 'Pido rescate por transferencia.'
    });
    const body = await response.json();

    assert.equal(response.status, 400);
    assert.equal(body.error.code, 'PAYMENT_INTENT_BLOCKED');
    assert.equal(repository.scans.length, 0);
  });
});

test('owner scans endpoint and read patch return owner events', async () => {
  await withQrServer(async ({ baseUrl, repository }) => {
    await repository.upsertRegisteredPet(validPetInput());
    await postJson(`${baseUrl}/api/v1/qr/public/MSC-QR-1/scans`, {
      locationSource: QrLocationSource.MANUAL,
      city: 'CABA',
      area: 'Flores'
    });

    const listResponse = await fetch(`${baseUrl}/api/v1/qr/owner/scans?unread=true`, {
      headers: { 'x-user-id': 'owner-1' }
    });
    const listBody = await listResponse.json();

    assert.equal(listResponse.status, 200);
    assert.equal(listBody.scans.length, 1);
    assert.equal(listBody.scans[0].area, 'Flores');

    const readResponse = await fetch(
      `${baseUrl}/api/v1/qr/owner/scans/${listBody.scans[0].id}/read`,
      { method: 'PATCH', headers: { 'x-user-id': 'owner-1' } }
    );
    const readBody = await readResponse.json();

    assert.equal(readResponse.status, 200);
    assert.ok(readBody.scan.readAt);
  });
});

class FakeQrRepository implements QrRepositoryPort {
  readonly pets = new Map<string, QrRegisteredPetRecord>();
  readonly scans: QrScanEventRecord[] = [];

  async upsertRegisteredPet(
    input: NormalizedQrPetInput
  ): Promise<QrRegisteredPetRecord> {
    const existing = this.pets.get(input.qrId);
    const now = new Date(Date.UTC(2026, 4, 19, 12, 0, 0));
    const pet: QrRegisteredPetRecord = {
      id: existing?.id ?? `registered-${this.pets.size + 1}`,
      ...input,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now
    };
    this.pets.set(input.qrId, pet);
    return pet;
  }

  async findRegisteredPetByQrId(
    qrId: string
  ): Promise<QrRegisteredPetRecord | null> {
    return this.pets.get(qrId) ?? null;
  }

  async createScanEvent(
    input: NormalizedQrScanInput
  ): Promise<QrScanEventRecord> {
    const pet = this.pets.get(input.qrId)!;
    const scan: QrScanEventRecord = {
      id: `scan-${this.scans.length + 1}`,
      ...input,
      scannedAt: new Date(Date.UTC(2026, 4, 19, 12, this.scans.length, 0)),
      status: QrScanStatus.PENDING,
      readAt: null,
      registeredPet: pet
    };
    this.scans.unshift(scan);
    return scan;
  }

  async findRecentDuplicateScan(input: {
    qrId: string;
    fingerprint: string;
    since: Date;
  }): Promise<QrScanEventRecord | null> {
    return (
      this.scans.find(
        (scan) =>
          scan.qrId === input.qrId &&
          scan.fingerprint === input.fingerprint &&
          scan.scannedAt >= input.since
      ) ?? null
    );
  }

  async listOwnerScans(input: {
    ownerUserId: string;
    unreadOnly: boolean;
  }): Promise<QrScanEventRecord[]> {
    return this.scans.filter(
      (scan) =>
        scan.ownerUserId === input.ownerUserId &&
        (!input.unreadOnly || scan.readAt == null)
    );
  }

  async markOwnerScanRead(input: {
    ownerUserId: string;
    scanId: string;
  }): Promise<QrScanEventRecord | null> {
    const scan = this.scans.find(
      (item) => item.id === input.scanId && item.ownerUserId === input.ownerUserId
    );
    if (!scan) return null;
    scan.readAt = new Date(Date.UTC(2026, 4, 19, 13, 0, 0));
    return scan;
  }
}

async function withQrServer(
  run: (fixture: { baseUrl: string; repository: FakeQrRepository }) => Promise<void>
): Promise<void> {
  const repository = new FakeQrRepository();
  const app = express();
  app.use(express.json());
  app.use('/api/v1', createQrRouter(new QrService(repository)));
  const server = http.createServer(app);

  await new Promise<void>((resolve) => server.listen(0, resolve));
  const address = server.address();
  assert.equal(typeof address, 'object');
  assert.ok(address);
  const baseUrl = `http://127.0.0.1:${(address as AddressInfo).port}`;

  try {
    await run({ baseUrl, repository });
  } finally {
    await new Promise<void>((resolve, reject) =>
      server.close((error) => (error ? reject(error) : resolve()))
    );
  }
}

function validPetInput(): NormalizedQrPetInput {
  return {
    qrId: 'MSC-QR-1',
    petId: 'pet-1',
    ownerUserId: 'owner-1',
    publicName: 'Luna',
    species: 'Perro',
    breed: 'Mestiza',
    color: 'Marron',
    publicNotes: 'Collar rojo',
    status: QrPetStatus.LOST
  };
}

function postJson(url: string, body: object): Promise<Response> {
  return fetch(url, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify(body)
  });
}
