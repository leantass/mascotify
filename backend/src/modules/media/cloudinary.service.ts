import { createHash } from 'node:crypto';

export type CloudinaryUploadSignature = {
  cloudName: string;
  apiKey: string;
  timestamp: number;
  signature: string;
  folder: string;
  resourceType: 'video';
  uploadUrl: string;
};

export type CloudinaryConfig = {
  cloudName?: string;
  apiKey?: string;
  apiSecret?: string;
  uploadFolder?: string;
};

export class CloudinaryConfigurationError extends Error {
  constructor() {
    super('Cloudinary media upload is not configured.');
  }
}

export class CloudinaryService {
  constructor(private readonly config: CloudinaryConfig = loadCloudinaryConfig()) {}

  createUploadSignature(): CloudinaryUploadSignature {
    const cloudName = normalizeRequired(this.config.cloudName);
    const apiKey = normalizeRequired(this.config.apiKey);
    const apiSecret = normalizeRequired(this.config.apiSecret);
    const folder = normalizeRequired(
      this.config.uploadFolder ?? 'mascotify/clips'
    );
    const timestamp = Math.floor(Date.now() / 1000);
    const paramsToSign = `folder=${folder}&timestamp=${timestamp}${apiSecret}`;
    const signature = createHash('sha1').update(paramsToSign).digest('hex');

    return {
      cloudName,
      apiKey,
      timestamp,
      signature,
      folder,
      resourceType: 'video',
      uploadUrl: `https://api.cloudinary.com/v1_1/${cloudName}/video/upload`
    };
  }
}

function loadCloudinaryConfig(): CloudinaryConfig {
  return {
    cloudName: process.env.CLOUDINARY_CLOUD_NAME,
    apiKey: process.env.CLOUDINARY_API_KEY,
    apiSecret: process.env.CLOUDINARY_API_SECRET,
    uploadFolder: process.env.CLOUDINARY_UPLOAD_FOLDER ?? 'mascotify/clips'
  };
}

function normalizeRequired(value: string | undefined): string {
  const normalizedValue = value?.trim();

  if (!normalizedValue) {
    throw new CloudinaryConfigurationError();
  }

  return normalizedValue;
}
