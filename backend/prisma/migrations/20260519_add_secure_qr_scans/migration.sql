CREATE TYPE "QrPetStatus" AS ENUM ('NORMAL', 'LOST', 'FOUND');

CREATE TYPE "QrLocationSource" AS ENUM ('DEVICE_GEOLOCATION', 'MANUAL', 'UNKNOWN');

CREATE TYPE "QrScanStatus" AS ENUM ('PENDING', 'REVIEWED', 'RESOLVED');

CREATE TABLE "QrRegisteredPet" (
  "id" TEXT NOT NULL,
  "qrId" TEXT NOT NULL,
  "petId" TEXT NOT NULL,
  "ownerUserId" TEXT NOT NULL,
  "publicName" TEXT NOT NULL,
  "species" TEXT NOT NULL,
  "breed" TEXT,
  "color" TEXT,
  "publicNotes" TEXT,
  "status" "QrPetStatus" NOT NULL DEFAULT 'NORMAL',
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,

  CONSTRAINT "QrRegisteredPet_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "QrScanEvent" (
  "id" TEXT NOT NULL,
  "qrId" TEXT NOT NULL,
  "registeredPetId" TEXT NOT NULL,
  "ownerUserId" TEXT NOT NULL,
  "scannedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "locationSource" "QrLocationSource" NOT NULL DEFAULT 'UNKNOWN',
  "latitude" DOUBLE PRECISION,
  "longitude" DOUBLE PRECISION,
  "accuracyMeters" DOUBLE PRECISION,
  "country" TEXT,
  "region" TEXT,
  "city" TEXT,
  "area" TEXT,
  "message" TEXT,
  "scannerContact" TEXT,
  "safetyFlag" BOOLEAN NOT NULL DEFAULT false,
  "readAt" TIMESTAMP(3),
  "status" "QrScanStatus" NOT NULL DEFAULT 'PENDING',
  "fingerprint" TEXT NOT NULL,

  CONSTRAINT "QrScanEvent_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "QrRegisteredPet_qrId_key" ON "QrRegisteredPet"("qrId");
CREATE INDEX "QrRegisteredPet_ownerUserId_idx" ON "QrRegisteredPet"("ownerUserId");
CREATE INDEX "QrRegisteredPet_petId_idx" ON "QrRegisteredPet"("petId");
CREATE INDEX "QrRegisteredPet_status_idx" ON "QrRegisteredPet"("status");
CREATE INDEX "QrScanEvent_qrId_scannedAt_idx" ON "QrScanEvent"("qrId", "scannedAt");
CREATE INDEX "QrScanEvent_ownerUserId_scannedAt_idx" ON "QrScanEvent"("ownerUserId", "scannedAt");
CREATE INDEX "QrScanEvent_ownerUserId_readAt_idx" ON "QrScanEvent"("ownerUserId", "readAt");

ALTER TABLE "QrScanEvent" ADD CONSTRAINT "QrScanEvent_registeredPetId_fkey"
  FOREIGN KEY ("registeredPetId") REFERENCES "QrRegisteredPet"("id")
  ON DELETE CASCADE ON UPDATE CASCADE;
