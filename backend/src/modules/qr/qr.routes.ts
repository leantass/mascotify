import { Router, type Request, type Response } from 'express';

import { QrError, QrService } from './qr.service';

export function createQrRouter(service = new QrService()): Router {
  const router = Router();

  router.post('/qr/pets', async (request, response) => {
    try {
      const result = await service.registerPet(
        readRequiredUserId(request),
        request.body
      );
      response.status(201).json(result);
    } catch (error) {
      sendQrError(response, error);
    }
  });

  router.get('/qr/public/:qrId', async (request, response) => {
    try {
      const pet = await service.getPublicPet(request.params.qrId);
      response.json({ pet });
    } catch (error) {
      sendQrError(response, error);
    }
  });

  router.post('/qr/public/:qrId/scans', async (request, response) => {
    try {
      const scan = await service.createPublicScan(
        request.params.qrId,
        request.body
      );
      response.status(201).json({ scan });
    } catch (error) {
      sendQrError(response, error);
    }
  });

  router.get('/qr/owner/scans', async (request, response) => {
    try {
      const scans = await service.listOwnerScans({
        ownerUserId: readRequiredUserId(request),
        unreadOnly: request.query.unread === 'true'
      });
      response.json({ scans });
    } catch (error) {
      sendQrError(response, error);
    }
  });

  router.patch('/qr/owner/scans/:id/read', async (request, response) => {
    try {
      const scan = await service.markOwnerScanRead(
        readRequiredUserId(request),
        request.params.id
      );
      response.json({ scan });
    } catch (error) {
      sendQrError(response, error);
    }
  });

  return router;
}

function readRequiredUserId(request: Request): string {
  const userId = request.header('x-user-id')?.trim();
  if (!userId) {
    throw new QrError(
      401,
      'UNAUTHENTICATED',
      'x-user-id header is required for this temporary backend.'
    );
  }

  return userId;
}

function sendQrError(response: Response, error: unknown): void {
  if (error instanceof QrError) {
    response.status(error.statusCode).json({
      error: {
        code: error.code,
        message: error.message,
        details: error.details
      }
    });
    return;
  }

  response.status(500).json({
    error: {
      code: 'INTERNAL_ERROR',
      message: 'Unexpected QR error.',
      details: []
    }
  });
}
