import type { Request, Response } from 'express';

import { env } from '../../config/env';

export type HealthResponse = {
  status: 'ok';
  service: string;
  timestamp: string;
};

export function buildHealthResponse(now = new Date()): HealthResponse {
  return {
    status: 'ok',
    service: env.serviceName,
    timestamp: now.toISOString()
  };
}

export function getHealth(_request: Request, response: Response): void {
  response.status(200).json(buildHealthResponse());
}
