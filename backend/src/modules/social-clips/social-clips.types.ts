import type { ClipStatus } from '@prisma/client';

export type ClipAuthor = {
  id: string;
  displayName: string;
  avatarUrl: string | null;
};

export type ClipRecord = {
  id: string;
  authorId: string;
  title: string;
  description: string;
  animalType: string;
  category: string;
  videoUrl: string;
  thumbnailUrl: string | null;
  durationSeconds: number | null;
  likesCount: number;
  commentsCount: number;
  sharesCount: number;
  status: ClipStatus;
  createdAt: Date;
  updatedAt: Date;
  author: ClipAuthor;
};

export type ClipResponse = ClipRecord & {
  isLiked: boolean;
  isFollowingAuthor: boolean;
};

export type CreateClipInput = {
  title?: unknown;
  description?: unknown;
  animalType?: unknown;
  category?: unknown;
  videoUrl?: unknown;
  thumbnailUrl?: unknown;
  durationSeconds?: unknown;
};

export type UpdateClipInput = Partial<CreateClipInput> & {
  status?: unknown;
};

export type NormalizedCreateClipInput = {
  authorId: string;
  title: string;
  description: string;
  animalType: string;
  category: string;
  videoUrl: string;
  thumbnailUrl?: string;
  durationSeconds?: number;
};

export type NormalizedUpdateClipInput = {
  title?: string;
  description?: string;
  animalType?: string;
  category?: string;
  videoUrl?: string;
  thumbnailUrl?: string | null;
  durationSeconds?: number | null;
  status?: ClipStatus;
};

export type FeedQuery = {
  viewerId?: string;
  cursor?: string;
  limit?: number;
};

export type FeedPage = {
  items: ClipResponse[];
  pageInfo: {
    nextCursor: string | null;
    hasNextPage: boolean;
  };
};

export type SocialClipsRepositoryPort = {
  createClip(input: NormalizedCreateClipInput): Promise<ClipRecord>;
  findClipById(id: string): Promise<ClipRecord | null>;
  updateClip(
    id: string,
    input: NormalizedUpdateClipInput
  ): Promise<ClipRecord | null>;
  listActiveClips(input: {
    cursor?: string;
    limit: number;
  }): Promise<ClipRecord[]>;
  findClipLike(clipId: string, userId: string): Promise<boolean>;
  addClipLike(clipId: string, userId: string): Promise<boolean>;
  removeClipLike(clipId: string, userId: string): Promise<boolean>;
  adjustClipLikes(clipId: string, delta: number): Promise<ClipRecord | null>;
  findUserFollow(followerId: string, followingId: string): Promise<boolean>;
  addUserFollow(followerId: string, followingId: string): Promise<boolean>;
  removeUserFollow(followerId: string, followingId: string): Promise<boolean>;
  incrementClipShares(clipId: string): Promise<ClipRecord | null>;
};
