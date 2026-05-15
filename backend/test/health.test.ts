import { createServer, type Server } from 'node:http';
import assert from 'node:assert/strict';
import test from 'node:test';

import { createApp } from '../src/app';

type TestServer = {
  baseUrl: string;
  close: () => Promise<void>;
};

async function startTestServer(): Promise<TestServer> {
  const server: Server = createServer(createApp());

  await new Promise<void>((resolve) => {
    server.listen(0, resolve);
  });

  const address = server.address();
  assert(address !== null && typeof address === 'object');

  return {
    baseUrl: `http://127.0.0.1:${address.port}`,
    close: () =>
      new Promise<void>((resolve, reject) => {
        server.close((error) => {
          if (error) {
            reject(error);
            return;
          }
          resolve();
        });
      })
  };
}

test('GET /health returns backend health status', async () => {
  const server = await startTestServer();

  try {
    const response = await fetch(`${server.baseUrl}/health`);
    const body = (await response.json()) as {
      status: string;
      service: string;
      timestamp: string;
    };

    assert.equal(response.status, 200);
    assert.equal(body.status, 'ok');
    assert.equal(body.service, 'mascotify-backend');
    assert.doesNotThrow(() => new Date(body.timestamp).toISOString());
  } finally {
    await server.close();
  }
});

test('GET /api/v1/health returns backend health status', async () => {
  const server = await startTestServer();

  try {
    const response = await fetch(`${server.baseUrl}/api/v1/health`);
    const body = (await response.json()) as {
      status: string;
      service: string;
      timestamp: string;
    };

    assert.equal(response.status, 200);
    assert.equal(body.status, 'ok');
    assert.equal(body.service, 'mascotify-backend');
    assert.doesNotThrow(() => new Date(body.timestamp).toISOString());
  } finally {
    await server.close();
  }
});

test('GET /health includes CORS headers for configured Flutter web origins', async () => {
  const server = await startTestServer();

  try {
    const response = await fetch(`${server.baseUrl}/health`, {
      headers: {
        Origin: 'http://localhost:8080'
      }
    });

    assert.equal(response.status, 200);
    assert.equal(
      response.headers.get('access-control-allow-origin'),
      'http://localhost:8080'
    );
    assert.match(
      response.headers.get('access-control-allow-headers') ?? '',
      /x-user-id/
    );
  } finally {
    await server.close();
  }
});

test('OPTIONS /api/v1/health answers preflight without auth or Cloudinary', async () => {
  const server = await startTestServer();

  try {
    const response = await fetch(`${server.baseUrl}/api/v1/health`, {
      method: 'OPTIONS',
      headers: {
        Origin: 'http://localhost:3000',
        'Access-Control-Request-Method': 'GET'
      }
    });

    assert.equal(response.status, 204);
    assert.equal(
      response.headers.get('access-control-allow-origin'),
      'http://localhost:3000'
    );
  } finally {
    await server.close();
  }
});

test('GET /health can allow any CORS origin when configured for Railway', async () => {
  const originalCorsOrigin = process.env.CORS_ORIGIN;
  process.env.CORS_ORIGIN = '*';
  const server = await startTestServer();

  try {
    const response = await fetch(`${server.baseUrl}/health`, {
      headers: {
        Origin: 'https://mascotify-web.example'
      }
    });

    assert.equal(response.status, 200);
    assert.equal(response.headers.get('access-control-allow-origin'), '*');
  } finally {
    await server.close();

    if (originalCorsOrigin == null) {
      delete process.env.CORS_ORIGIN;
    } else {
      process.env.CORS_ORIGIN = originalCorsOrigin;
    }
  }
});
