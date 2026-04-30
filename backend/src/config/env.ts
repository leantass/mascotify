export type AppEnv = {
  nodeEnv: string;
  port: number;
  serviceName: string;
};

const DEFAULT_PORT = 4000;

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

export function loadEnv(): AppEnv {
  return {
    nodeEnv: process.env.NODE_ENV ?? 'development',
    port: parsePort(process.env.PORT),
    serviceName: 'mascotify-backend'
  };
}

export const env = loadEnv();
