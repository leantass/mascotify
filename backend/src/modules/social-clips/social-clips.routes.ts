import { Router, type Request, type Response } from 'express';

import {
  CloudinaryConfigurationError,
  CloudinaryService
} from '../media/cloudinary.service';
import {
  SocialClipsError,
  SocialClipsService
} from './social-clips.service';

export function createSocialClipsRouter(
  service = new SocialClipsService(),
  mediaService = new CloudinaryService()
): Router {
  const router = Router();

  router.get('/clips/feed', async (request, response) => {
    try {
      const feed = await service.getFeed({
        viewerId: readOptionalUserId(request),
        cursor: readQueryString(request, 'cursor'),
        limit: readQueryInteger(request, 'limit')
      });

      response.json(feed);
    } catch (error) {
      sendError(response, error);
    }
  });

  router.get('/clips/:id', async (request, response) => {
    try {
      const clip = await service.getClipById(
        request.params.id,
        readOptionalUserId(request)
      );

      response.json({ clip });
    } catch (error) {
      sendError(response, error);
    }
  });

  router.post('/clips/upload-signature', async (request, response) => {
    try {
      readRequiredUserId(request);
      response.json(mediaService.createUploadSignature());
    } catch (error) {
      sendError(response, error);
    }
  });

  router.post('/clips', async (request, response) => {
    try {
      const clip = await service.createClip(
        readRequiredUserId(request),
        request.body
      );

      response.status(201).json({ clip });
    } catch (error) {
      sendError(response, error);
    }
  });

  router.patch('/clips/:id', async (request, response) => {
    try {
      readRequiredUserId(request);
      const clip = await service.updateClip(request.params.id, request.body);

      response.json({ clip });
    } catch (error) {
      sendError(response, error);
    }
  });

  router.delete('/clips/:id', async (request, response) => {
    try {
      readRequiredUserId(request);
      await service.deleteClip(request.params.id);

      response.status(204).send();
    } catch (error) {
      sendError(response, error);
    }
  });

  router.post('/clips/:id/like', async (request, response) => {
    try {
      const clip = await service.likeClip(
        request.params.id,
        readRequiredUserId(request)
      );

      response.json({ clip });
    } catch (error) {
      sendError(response, error);
    }
  });

  router.delete('/clips/:id/like', async (request, response) => {
    try {
      const clip = await service.unlikeClip(
        request.params.id,
        readRequiredUserId(request)
      );

      response.json({ clip });
    } catch (error) {
      sendError(response, error);
    }
  });

  router.post('/clips/:id/share', async (request, response) => {
    try {
      const clip = await service.shareClip(
        request.params.id,
        readOptionalUserId(request)
      );

      response.json({ clip });
    } catch (error) {
      sendError(response, error);
    }
  });

  router.post('/users/:id/follow', async (request, response) => {
    try {
      const result = await service.followUser(
        readRequiredUserId(request),
        request.params.id
      );

      response.json(result);
    } catch (error) {
      sendError(response, error);
    }
  });

  router.delete('/users/:id/follow', async (request, response) => {
    try {
      const result = await service.unfollowUser(
        readRequiredUserId(request),
        request.params.id
      );

      response.json(result);
    } catch (error) {
      sendError(response, error);
    }
  });

  return router;
}

function readRequiredUserId(request: Request): string {
  const userId = readOptionalUserId(request);

  if (!userId) {
    throw new SocialClipsError(
      401,
      'UNAUTHENTICATED',
      'x-user-id header is required for this temporary backend.'
    );
  }

  return userId;
}

function readOptionalUserId(request: Request): string | undefined {
  const header = request.header('x-user-id')?.trim();
  return header ? header : undefined;
}

function readQueryString(
  request: Request,
  key: string
): string | undefined {
  const value = request.query[key];

  if (typeof value === 'string' && value.trim()) {
    return value.trim();
  }

  return undefined;
}

function readQueryInteger(
  request: Request,
  key: string
): number | undefined {
  const value = request.query[key];

  if (typeof value !== 'string' || !value.trim()) {
    return undefined;
  }

  return Number(value);
}

function sendError(response: Response, error: unknown): void {
  if (error instanceof SocialClipsError) {
    response.status(error.statusCode).json({
      error: {
        code: error.code,
        message: error.message,
        details: error.details
      }
    });
    return;
  }

  if (error instanceof CloudinaryConfigurationError) {
    response.status(503).json({
      error: {
        code: 'MEDIA_UPLOAD_DISABLED',
        message: error.message,
        details: []
      }
    });
    return;
  }

  response.status(500).json({
    error: {
      code: 'INTERNAL_ERROR',
      message: 'Unexpected social clips error.',
      details: []
    }
  });
}
