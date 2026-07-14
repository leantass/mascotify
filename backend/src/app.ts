import express, {
  type Express,
  type NextFunction,
  type Request,
  type Response
} from 'express';

import { loadEnv } from './config/env';
import { createHealthRouter } from './modules/health/health.routes';
import { createQrRouter } from './modules/qr/qr.routes';
import { createSocialClipsRouter } from './modules/social-clips/social-clips.routes';

export function createApp(): Express {
  const app = express();
  const env = loadEnv();
  const healthRouter = createHealthRouter();
  const qrRouter = createQrRouter();
  const socialClipsRouter = createSocialClipsRouter();

  app.disable('x-powered-by');
  app.use(configureSecurityHeaders);
  app.use(configureCors(env.corsOrigins));
  app.use(express.json({ limit: '256kb' }));

  app.use('/health', healthRouter);
  app.use('/api/v1/health', healthRouter);
  app.use('/api/v1', qrRouter);
  app.use('/api/v1', socialClipsRouter);

  app.use((_request: Request, response: Response) => {
    response.status(404).json({
      error: {
        code: 'NOT_FOUND',
        message: 'Resource not found',
        details: []
      }
    });
  });

  return app;
}

function configureSecurityHeaders(
  _request: Request,
  response: Response,
  next: NextFunction
) {
  response.header('X-Content-Type-Options', 'nosniff');
  response.header('Referrer-Policy', 'no-referrer');
  response.header('X-Frame-Options', 'DENY');
  response.header(
    'Permissions-Policy',
    'camera=(), microphone=(), geolocation=()'
  );
  response.header("Content-Security-Policy", "default-src 'none'; frame-ancestors 'none'");
  next();
}

function configureCors(allowedOrigins: string[]) {
  const allowsAnyOrigin = allowedOrigins.includes('*');

  return (request: Request, response: Response, next: NextFunction) => {
    const origin = request.header('origin');

    if (origin != null && (allowsAnyOrigin || allowedOrigins.includes(origin))) {
      response.header(
        'Access-Control-Allow-Origin',
        allowsAnyOrigin ? '*' : origin
      );

      if (!allowsAnyOrigin) {
        response.header('Vary', 'Origin');
      }
    }

    response.header(
      'Access-Control-Allow-Headers',
      'Content-Type, Authorization, x-user-id'
    );
    response.header(
      'Access-Control-Allow-Methods',
      'GET, POST, PATCH, DELETE, OPTIONS'
    );

    if (request.method === 'OPTIONS') {
      response.status(204).send();
      return;
    }

    next();
  };
}
