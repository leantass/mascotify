import assert from 'node:assert/strict';
import { createServer, type Server } from 'node:http';
import test from 'node:test';

import { createApp } from '../src/app';
import {
  CloudinaryConfigurationError,
  CloudinaryService
} from '../src/modules/media/cloudinary.service';

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

test('CloudinaryService creates signed upload params without exposing api secret', () => {
  const service = new CloudinaryService({
    cloudName: 'demo-cloud',
    apiKey: 'api-key-123',
    apiSecret: 'super-secret',
    uploadFolder: 'mascotify/clips'
  });

  const signature = service.createUploadSignature();

  assert.equal(signature.cloudName, 'demo-cloud');
  assert.equal(signature.apiKey, 'api-key-123');
  assert.equal(signature.folder, 'mascotify/clips');
  assert.equal(signature.resourceType, 'video');
  assert.match(signature.uploadUrl, /\/video\/upload$/);
  assert.equal('apiSecret' in signature, false);
  assert.equal(JSON.stringify(signature).includes('super-secret'), false);
});

test('CloudinaryService reports a controlled error when configuration is missing', () => {
  const service = new CloudinaryService({
    cloudName: '',
    apiKey: 'api-key-123',
    apiSecret: 'super-secret',
    uploadFolder: 'mascotify/clips'
  });

  assert.throws(
    () => service.createUploadSignature(),
    CloudinaryConfigurationError
  );
});

test('POST /api/v1/clips/upload-signature requires x-user-id', async () => {
  const server = await startTestServer();

  try {
    const response = await fetch(
      `${server.baseUrl}/api/v1/clips/upload-signature`,
      { method: 'POST' }
    );
    const body = (await response.json()) as {
      error: { code: string; message: string };
    };

    assert.equal(response.status, 401);
    assert.equal(body.error.code, 'UNAUTHENTICATED');
  } finally {
    await server.close();
  }
});

test('POST /api/v1/clips/upload-signature returns a controlled disabled error without config', async () => {
  const server = await startTestServer();

  try {
    const response = await fetch(
      `${server.baseUrl}/api/v1/clips/upload-signature`,
      {
        method: 'POST',
        headers: { 'x-user-id': 'user_1' }
      }
    );
    const body = (await response.json()) as {
      error: { code: string; message: string };
    };

    assert.equal(response.status, 503);
    assert.equal(body.error.code, 'MEDIA_UPLOAD_DISABLED');
  } finally {
    await server.close();
  }
});
