export type AppEnv = {
  nodeEnv: string;
  port: number;
  serviceName: string;
  corsOrigins: string[];
};

const DEFAULT_PORT = 4000;
const DEFAULT_CORS_ORIGINS = [
  'http://localhost:3000',
  'http://localhost:5000',
  'http://localhost:8080',
  'http://localhost:52609'
];

function parsePort(value: string | undefined): number {
  if (value == null || value.trim() === '') {
    return DEFAULT_PORT;
  }

  const parsed = Number(value);
  if (!Number.isInteger(parsed) || parsed <= 0 || parsed > 65535) {
    throw new Error(`Invalid PORT value: ${value}`);
  }

  return parsed;
}

function parseCorsOrigins(value: string | undefined): string[] {
  if (value == null || value.trim() === '') {
    return DEFAULT_CORS_ORIGINS;
  }

  return value
    .split(',')
    .map((origin) => origin.trim())
    .filter((origin) => origin.length > 0);
}

export function loadEnv(): AppEnv {
  return {
    nodeEnv: process.env.NODE_ENV ?? 'development',
    port: parsePort(process.env.PORT),
    serviceName: 'mascotify-backend',
    corsOrigins: parseCorsOrigins(process.env.CORS_ORIGIN)
  };
}

export const env = loadEnv();
