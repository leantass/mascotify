import { Router } from 'express';

import { getHealth } from './health.controller';

export function createHealthRouter(): Router {
  const router = Router();

  router.get('/', getHealth);

  return router;
}
