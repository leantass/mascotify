import type { PrismaClient } from '@prisma/client';
import { Prisma } from '@prisma/client';

import { prisma } from '../../shared/database/prisma';
import type {
  NormalizedQrPetInput,
  NormalizedQrScanInput,
  QrRegisteredPetRecord,
  QrRepositoryPort,
  QrScanEventRecord
} from './qr.types';

const scanWithPet = {
  registeredPet: true
};

type PrismaScanWithPet = Prisma.QrScanEventGetPayload<{
  include: typeof scanWithPet;
}>;

export class PrismaQrRepository implements QrRepositoryPort {
  constructor(private readonly client: PrismaClient = prisma) {}

  async upsertRegisteredPet(
    input: NormalizedQrPetInput
  ): Promise<QrRegisteredPetRecord> {
    return this.client.qrRegisteredPet.upsert({
      where: { qrId: input.qrId },
      create: input,
      update: input
    });
  }

  async findRegisteredPetByQrId(
    qrId: string
  ): Promise<QrRegisteredPetRecord | null> {
    return this.client.qrRegisteredPet.findUnique({ where: { qrId } });
  }

  async createScanEvent(
    input: NormalizedQrScanInput
  ): Promise<QrScanEventRecord> {
    const scan = await this.client.qrScanEvent.create({
      data: input,
      include: scanWithPet
    });

    return mapScan(scan);
  }

  async findRecentDuplicateScan(input: {
    qrId: string;
    fingerprint: string;
    since: Date;
  }): Promise<QrScanEventRecord | null> {
    const scan = await this.client.qrScanEvent.findFirst({
      where: {
        qrId: input.qrId,
        fingerprint: input.fingerprint,
        scannedAt: { gte: input.since }
      },
      orderBy: { scannedAt: 'desc' },
      include: scanWithPet
    });

    return scan ? mapScan(scan) : null;
  }

  async listOwnerScans(input: {
    ownerUserId: string;
    unreadOnly: boolean;
  }): Promise<QrScanEventRecord[]> {
    const scans = await this.client.qrScanEvent.findMany({
      where: {
        ownerUserId: input.ownerUserId,
        readAt: input.unreadOnly ? null : undefined
      },
      orderBy: { scannedAt: 'desc' },
      take: 80,
      include: scanWithPet
    });

    return scans.map(mapScan);
  }

  async markOwnerScanRead(input: {
    ownerUserId: string;
    scanId: string;
  }): Promise<QrScanEventRecord | null> {
    const result = await this.client.qrScanEvent.updateMany({
      where: {
        id: input.scanId,
        ownerUserId: input.ownerUserId
      },
      data: {
        readAt: new Date()
      }
    });

    if (result.count === 0) {
      return null;
    }

    const scan = await this.client.qrScanEvent.findUnique({
      where: { id: input.scanId },
      include: scanWithPet
    });

    return scan ? mapScan(scan) : null;
  }
}

function mapScan(scan: PrismaScanWithPet): QrScanEventRecord {
  return {
    ...scan,
    registeredPet: scan.registeredPet
  };
}
