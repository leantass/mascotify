import type { PrismaClient, UserProfile } from '@prisma/client';
import { Prisma } from '@prisma/client';

import { prisma } from '../../shared/database/prisma';
import type {
  ClipAuthor,
  ClipRecord,
  NormalizedCreateClipInput,
  NormalizedUpdateClipInput,
  SocialClipsRepositoryPort
} from './social-clips.types';

const clipWithAuthor = {
  author: {
    include: {
      profiles: true
    }
  }
};

type PrismaClipWithAuthor = Prisma.ClipGetPayload<{
  include: typeof clipWithAuthor;
}>;

export class PrismaSocialClipsRepository
  implements SocialClipsRepositoryPort
{
  constructor(private readonly client: PrismaClient = prisma) {}

  async createClip(input: NormalizedCreateClipInput): Promise<ClipRecord> {
    const clip = await this.client.clip.create({
      data: input,
      include: clipWithAuthor
    });

    return mapClip(clip);
  }

  async findClipById(id: string): Promise<ClipRecord | null> {
    const clip = await this.client.clip.findUnique({
      where: { id },
      include: clipWithAuthor
    });

    return clip ? mapClip(clip) : null;
  }

  async updateClip(
    id: string,
    input: NormalizedUpdateClipInput
  ): Promise<ClipRecord | null> {
    try {
      const clip = await this.client.clip.update({
        where: { id },
        data: input,
        include: clipWithAuthor
      });

      return mapClip(clip);
    } catch (error) {
      if (isRecordNotFound(error)) {
        return null;
      }

      throw error;
    }
  }

  async listActiveClips(input: {
    cursor?: string;
    limit: number;
  }): Promise<ClipRecord[]> {
    const clips = await this.client.clip.findMany({
      where: {
        status: 'ACTIVE'
      },
      orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
      take: input.limit,
      skip: input.cursor ? 1 : 0,
      cursor: input.cursor ? { id: input.cursor } : undefined,
      include: clipWithAuthor
    });

    return clips.map(mapClip);
  }

  async findClipLike(clipId: string, userId: string): Promise<boolean> {
    const like = await this.client.clipLike.findUnique({
      where: {
        clipId_userId: {
          clipId,
          userId
        }
      }
    });

    return Boolean(like);
  }

  async addClipLike(clipId: string, userId: string): Promise<boolean> {
    try {
      await this.client.clipLike.create({
        data: {
          clipId,
          userId
        }
      });

      return true;
    } catch (error) {
      if (isUniqueConflict(error)) {
        return false;
      }

      throw error;
    }
  }

  async removeClipLike(clipId: string, userId: string): Promise<boolean> {
    const result = await this.client.clipLike.deleteMany({
      where: {
        clipId,
        userId
      }
    });

    return result.count > 0;
  }

  async adjustClipLikes(
    clipId: string,
    delta: number
  ): Promise<ClipRecord | null> {
    try {
      const clip = await this.client.clip.update({
        where: { id: clipId },
        data: {
          likesCount: {
            increment: delta
          }
        },
        include: clipWithAuthor
      });

      return mapClip({
        ...clip,
        likesCount: Math.max(clip.likesCount, 0)
      });
    } catch (error) {
      if (isRecordNotFound(error)) {
        return null;
      }

      throw error;
    }
  }

  async findUserFollow(
    followerId: string,
    followingId: string
  ): Promise<boolean> {
    const follow = await this.client.userFollow.findUnique({
      where: {
        followerId_followingId: {
          followerId,
          followingId
        }
      }
    });

    return Boolean(follow);
  }

  async addUserFollow(
    followerId: string,
    followingId: string
  ): Promise<boolean> {
    try {
      await this.client.userFollow.create({
        data: {
          followerId,
          followingId
        }
      });

      return true;
    } catch (error) {
      if (isUniqueConflict(error)) {
        return false;
      }

      throw error;
    }
  }

  async removeUserFollow(
    followerId: string,
    followingId: string
  ): Promise<boolean> {
    const result = await this.client.userFollow.deleteMany({
      where: {
        followerId,
        followingId
      }
    });

    return result.count > 0;
  }

  async incrementClipShares(clipId: string): Promise<ClipRecord | null> {
    try {
      const clip = await this.client.clip.update({
        where: { id: clipId },
        data: {
          sharesCount: {
            increment: 1
          }
        },
        include: clipWithAuthor
      });

      return mapClip(clip);
    } catch (error) {
      if (isRecordNotFound(error)) {
        return null;
      }

      throw error;
    }
  }
}

function mapClip(clip: PrismaClipWithAuthor): ClipRecord {
  return {
    id: clip.id,
    authorId: clip.authorId,
    title: clip.title,
    description: clip.description,
    animalType: clip.animalType,
    category: clip.category,
    videoUrl: clip.videoUrl,
    thumbnailUrl: clip.thumbnailUrl,
    durationSeconds: clip.durationSeconds,
    likesCount: clip.likesCount,
    commentsCount: clip.commentsCount,
    sharesCount: clip.sharesCount,
    status: clip.status,
    createdAt: clip.createdAt,
    updatedAt: clip.updatedAt,
    author: mapAuthor(clip.author)
  };
}

function mapAuthor(author: {
  id: string;
  displayName: string;
  profiles: UserProfile[];
}): ClipAuthor {
  return {
    id: author.id,
    displayName: author.displayName,
    avatarUrl:
      author.profiles.find((profile) => profile.avatarUrl)?.avatarUrl ?? null
  };
}

function isUniqueConflict(error: unknown): boolean {
  return (
    error instanceof Prisma.PrismaClientKnownRequestError &&
    error.code === 'P2002'
  );
}

function isRecordNotFound(error: unknown): boolean {
  return (
    error instanceof Prisma.PrismaClientKnownRequestError &&
    error.code === 'P2025'
  );
}
