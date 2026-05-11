import { ClipStatus } from '@prisma/client';

import { PrismaSocialClipsRepository } from './social-clips.repository';
import type {
  ClipRecord,
  ClipResponse,
  CreateClipInput,
  FeedPage,
  FeedQuery,
  NormalizedCreateClipInput,
  NormalizedUpdateClipInput,
  SocialClipsRepositoryPort,
  UpdateClipInput
} from './social-clips.types';

const DEFAULT_FEED_LIMIT = 10;
const MAX_FEED_LIMIT = 50;

export class SocialClipsError extends Error {
  constructor(
    readonly statusCode: number,
    readonly code: string,
    message: string,
    readonly details: Array<{ field: string; message: string }> = []
  ) {
    super(message);
  }
}

export class SocialClipsService {
  constructor(
    private readonly clipsRepository: SocialClipsRepositoryPort = new PrismaSocialClipsRepository()
  ) {}

  async createClip(
    authorId: string,
    input: CreateClipInput
  ): Promise<ClipResponse> {
    const normalizedInput = normalizeCreateClipInput(authorId, input);
    const clip = await this.clipsRepository.createClip(normalizedInput);
    return this.decorateClip(clip, authorId);
  }

  async getClipById(
    clipId: string,
    viewerId?: string
  ): Promise<ClipResponse> {
    const clip = await this.clipsRepository.findClipById(normalizeId(clipId));

    if (!clip || clip.status === ClipStatus.DELETED) {
      throw new SocialClipsError(404, 'NOT_FOUND', 'Clip not found.');
    }

    return this.decorateClip(clip, viewerId);
  }

  async updateClip(
    clipId: string,
    input: UpdateClipInput
  ): Promise<ClipResponse> {
    const normalizedInput = normalizeUpdateClipInput(input);
    const updatedClip = await this.clipsRepository.updateClip(
      normalizeId(clipId),
      normalizedInput
    );

    if (!updatedClip) {
      throw new SocialClipsError(404, 'NOT_FOUND', 'Clip not found.');
    }

    return this.decorateClip(updatedClip, undefined);
  }

  async deleteClip(clipId: string): Promise<void> {
    const updatedClip = await this.clipsRepository.updateClip(
      normalizeId(clipId),
      { status: ClipStatus.DELETED }
    );

    if (!updatedClip) {
      throw new SocialClipsError(404, 'NOT_FOUND', 'Clip not found.');
    }
  }

  async getFeed(query: FeedQuery): Promise<FeedPage> {
    const limit = normalizeLimit(query.limit);
    const clips = await this.clipsRepository.listActiveClips({
      cursor: normalizeOptionalId(query.cursor),
      limit: limit + 1
    });
    const items = clips.slice(0, limit);
    const decoratedItems = await Promise.all(
      items.map((clip) => this.decorateClip(clip, query.viewerId))
    );

    return {
      items: decoratedItems,
      pageInfo: {
        nextCursor: clips.length > limit ? items[items.length - 1]?.id ?? null : null,
        hasNextPage: clips.length > limit
      }
    };
  }

  async likeClip(clipId: string, userId: string): Promise<ClipResponse> {
    const normalizedClipId = normalizeId(clipId);
    const normalizedUserId = normalizeId(userId);
    await this.ensureClipExists(normalizedClipId);

    const created = await this.clipsRepository.addClipLike(
      normalizedClipId,
      normalizedUserId
    );
    const clip = created
      ? await this.clipsRepository.adjustClipLikes(normalizedClipId, 1)
      : await this.clipsRepository.findClipById(normalizedClipId);

    if (!clip) {
      throw new SocialClipsError(404, 'NOT_FOUND', 'Clip not found.');
    }

    return this.decorateClip(clip, normalizedUserId);
  }

  async unlikeClip(clipId: string, userId: string): Promise<ClipResponse> {
    const normalizedClipId = normalizeId(clipId);
    const normalizedUserId = normalizeId(userId);
    await this.ensureClipExists(normalizedClipId);

    const removed = await this.clipsRepository.removeClipLike(
      normalizedClipId,
      normalizedUserId
    );
    const clip = removed
      ? await this.clipsRepository.adjustClipLikes(normalizedClipId, -1)
      : await this.clipsRepository.findClipById(normalizedClipId);

    if (!clip) {
      throw new SocialClipsError(404, 'NOT_FOUND', 'Clip not found.');
    }

    return this.decorateClip(clip, normalizedUserId);
  }

  async followUser(
    followerId: string,
    followingId: string
  ): Promise<{ followingId: string; isFollowing: true }> {
    const normalizedFollowerId = normalizeId(followerId);
    const normalizedFollowingId = normalizeId(followingId);

    if (normalizedFollowerId === normalizedFollowingId) {
      throw new SocialClipsError(
        400,
        'VALIDATION_ERROR',
        'Cannot follow the same user.',
        [{ field: 'followingId', message: 'Must be different from follower.' }]
      );
    }

    await this.clipsRepository.addUserFollow(
      normalizedFollowerId,
      normalizedFollowingId
    );

    return { followingId: normalizedFollowingId, isFollowing: true };
  }

  async unfollowUser(
    followerId: string,
    followingId: string
  ): Promise<{ followingId: string; isFollowing: false }> {
    const normalizedFollowerId = normalizeId(followerId);
    const normalizedFollowingId = normalizeId(followingId);
    await this.clipsRepository.removeUserFollow(
      normalizedFollowerId,
      normalizedFollowingId
    );

    return { followingId: normalizedFollowingId, isFollowing: false };
  }

  async shareClip(clipId: string, viewerId?: string): Promise<ClipResponse> {
    const clip = await this.clipsRepository.incrementClipShares(
      normalizeId(clipId)
    );

    if (!clip) {
      throw new SocialClipsError(404, 'NOT_FOUND', 'Clip not found.');
    }

    return this.decorateClip(clip, viewerId);
  }

  private async ensureClipExists(clipId: string): Promise<void> {
    const clip = await this.clipsRepository.findClipById(clipId);

    if (!clip || clip.status === ClipStatus.DELETED) {
      throw new SocialClipsError(404, 'NOT_FOUND', 'Clip not found.');
    }
  }

  private async decorateClip(
    clip: ClipRecord,
    viewerId: string | undefined
  ): Promise<ClipResponse> {
    const normalizedViewerId = normalizeOptionalId(viewerId);

    if (!normalizedViewerId) {
      return {
        ...clip,
        isLiked: false,
        isFollowingAuthor: false
      };
    }

    const [isLiked, isFollowingAuthor] = await Promise.all([
      this.clipsRepository.findClipLike(clip.id, normalizedViewerId),
      this.clipsRepository.findUserFollow(normalizedViewerId, clip.authorId)
    ]);

    return {
      ...clip,
      isLiked,
      isFollowingAuthor
    };
  }
}

export function normalizeCreateClipInput(
  authorId: string,
  input: CreateClipInput
): NormalizedCreateClipInput {
  const normalizedAuthorId = normalizeId(authorId);
  const title = normalizeRequiredText(input.title, 'title');
  const description = normalizeRequiredText(input.description, 'description');
  const animalType = normalizeRequiredText(input.animalType, 'animalType');
  const category = normalizeRequiredText(input.category, 'category');
  const videoUrl = normalizeRequiredText(input.videoUrl, 'videoUrl');
  const thumbnailUrl = normalizeOptionalText(input.thumbnailUrl);
  const cloudinaryPublicId = normalizeOptionalText(input.cloudinaryPublicId);
  const durationSeconds = normalizeOptionalPositiveInteger(
    input.durationSeconds,
    'durationSeconds'
  );

  return {
    authorId: normalizedAuthorId,
    title,
    description,
    animalType,
    category,
    videoUrl,
    thumbnailUrl,
    cloudinaryPublicId,
    durationSeconds
  };
}

export function normalizeUpdateClipInput(
  input: UpdateClipInput
): NormalizedUpdateClipInput {
  const normalizedInput: NormalizedUpdateClipInput = {};

  if ('title' in input) {
    normalizedInput.title = normalizeRequiredText(input.title, 'title');
  }

  if ('description' in input) {
    normalizedInput.description = normalizeRequiredText(
      input.description,
      'description'
    );
  }

  if ('animalType' in input) {
    normalizedInput.animalType = normalizeRequiredText(
      input.animalType,
      'animalType'
    );
  }

  if ('category' in input) {
    normalizedInput.category = normalizeRequiredText(input.category, 'category');
  }

  if ('videoUrl' in input) {
    normalizedInput.videoUrl = normalizeRequiredText(input.videoUrl, 'videoUrl');
  }

  if ('thumbnailUrl' in input) {
    normalizedInput.thumbnailUrl = normalizeNullableText(input.thumbnailUrl);
  }

  if ('cloudinaryPublicId' in input) {
    normalizedInput.cloudinaryPublicId = normalizeNullableText(
      input.cloudinaryPublicId
    );
  }

  if ('durationSeconds' in input) {
    normalizedInput.durationSeconds = normalizeOptionalPositiveInteger(
      input.durationSeconds,
      'durationSeconds'
    ) ?? null;
  }

  if ('status' in input) {
    normalizedInput.status = normalizeClipStatus(input.status);
  }

  return normalizedInput;
}

function normalizeId(value: string): string {
  const normalizedValue = value.trim();

  if (!normalizedValue) {
    throw new SocialClipsError(400, 'VALIDATION_ERROR', 'Id is required.', [
      { field: 'id', message: 'Required.' }
    ]);
  }

  return normalizedValue;
}

function normalizeOptionalId(value: string | undefined): string | undefined {
  const normalizedValue = value?.trim();
  return normalizedValue ? normalizedValue : undefined;
}

function normalizeRequiredText(value: unknown, field: string): string {
  if (typeof value !== 'string') {
    throw new SocialClipsError(
      400,
      'VALIDATION_ERROR',
      'Clip data is invalid.',
      [{ field, message: 'Must be a string.' }]
    );
  }

  const normalizedValue = value.trim();

  if (!normalizedValue) {
    throw new SocialClipsError(
      400,
      'VALIDATION_ERROR',
      'Clip data is invalid.',
      [{ field, message: 'Required.' }]
    );
  }

  return normalizedValue;
}

function normalizeOptionalText(value: unknown): string | undefined {
  if (value === undefined || value === null) {
    return undefined;
  }

  if (typeof value !== 'string') {
    throw new SocialClipsError(
      400,
      'VALIDATION_ERROR',
      'Clip data is invalid.'
    );
  }

  const normalizedValue = value.trim();
  return normalizedValue ? normalizedValue : undefined;
}

function normalizeNullableText(value: unknown): string | null {
  if (value === undefined || value === null) {
    return null;
  }

  return normalizeOptionalText(value) ?? null;
}

function normalizeOptionalPositiveInteger(
  value: unknown,
  field: string
): number | undefined {
  if (value === undefined || value === null) {
    return undefined;
  }

  if (!Number.isInteger(value) || Number(value) < 1) {
    throw new SocialClipsError(
      400,
      'VALIDATION_ERROR',
      'Clip data is invalid.',
      [{ field, message: 'Must be a positive integer.' }]
    );
  }

  return Number(value);
}

function normalizeClipStatus(value: unknown): ClipStatus {
  if (
    value !== ClipStatus.ACTIVE &&
    value !== ClipStatus.HIDDEN &&
    value !== ClipStatus.REPORTED &&
    value !== ClipStatus.DELETED
  ) {
    throw new SocialClipsError(
      400,
      'VALIDATION_ERROR',
      'Clip status is invalid.',
      [{ field: 'status', message: 'Unsupported status.' }]
    );
  }

  return value;
}

function normalizeLimit(value: number | undefined): number {
  if (!value) {
    return DEFAULT_FEED_LIMIT;
  }

  if (!Number.isInteger(value) || value < 1) {
    throw new SocialClipsError(
      400,
      'VALIDATION_ERROR',
      'Feed limit is invalid.',
      [{ field: 'limit', message: 'Must be a positive integer.' }]
    );
  }

  return Math.min(value, MAX_FEED_LIMIT);
}
