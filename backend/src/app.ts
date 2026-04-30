import express, { type Express, type Request, type Response } from 'express';

import { createHealthRouter } from './modules/health/health.routes';

export function createApp(): Express {
  const app = express();
  const healthRouter = createHealthRouter();

  app.disable('x-powered-by');
  app.use(express.json());

  app.use('/health', healthRouter);
  app.use('/api/v1/health', healthRouter);

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
