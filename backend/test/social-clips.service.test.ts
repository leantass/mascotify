import assert from 'node:assert/strict';
import test from 'node:test';

import { ClipStatus } from '@prisma/client';

import { SocialClipsService } from '../src/modules/social-clips/social-clips.service';
import type {
  ClipAuthor,
  ClipRecord,
  NormalizedCreateClipInput,
  NormalizedUpdateClipInput,
  SocialClipsRepositoryPort
} from '../src/modules/social-clips/social-clips.types';

class FakeSocialClipsRepository implements SocialClipsRepositoryPort {
  readonly clips = new Map<string, ClipRecord>();
  readonly likes = new Set<string>();
  readonly follows = new Set<string>();
  private nextClipNumber = 1;

  async createClip(input: NormalizedCreateClipInput): Promise<ClipRecord> {
    const now = new Date(
      Date.UTC(2026, 4, 11, 12, this.nextClipNumber, 0)
    );
    const clip: ClipRecord = {
      id: `clip_${this.nextClipNumber}`,
      authorId: input.authorId,
      title: input.title,
      description: input.description,
      animalType: input.animalType,
      category: input.category,
      videoUrl: input.videoUrl,
      thumbnailUrl: input.thumbnailUrl ?? null,
      cloudinaryPublicId: input.cloudinaryPublicId ?? null,
      durationSeconds: input.durationSeconds ?? null,
      likesCount: 0,
      commentsCount: 0,
      sharesCount: 0,
      status: ClipStatus.ACTIVE,
      createdAt: now,
      updatedAt: now,
      author: makeAuthor(input.authorId)
    };

    this.nextClipNumber += 1;
    this.clips.set(clip.id, clip);
    return clip;
  }

  async findClipById(id: string): Promise<ClipRecord | null> {
    return this.clips.get(id) ?? null;
  }

  async updateClip(
    id: string,
    input: NormalizedUpdateClipInput
  ): Promise<ClipRecord | null> {
    const clip = this.clips.get(id);

    if (!clip) {
      return null;
    }

    const updatedClip: ClipRecord = {
      ...clip,
      ...input,
      thumbnailUrl:
        input.thumbnailUrl === undefined ? clip.thumbnailUrl : input.thumbnailUrl,
      cloudinaryPublicId:
        input.cloudinaryPublicId === undefined
          ? clip.cloudinaryPublicId
          : input.cloudinaryPublicId,
      durationSeconds:
        input.durationSeconds === undefined
          ? clip.durationSeconds
          : input.durationSeconds,
      updatedAt: new Date(clip.updatedAt.getTime() + 1000)
    };

    this.clips.set(id, updatedClip);
    return updatedClip;
  }

  async listActiveClips(input: {
    cursor?: string;
    limit: number;
  }): Promise<ClipRecord[]> {
    const sortedClips = [...this.clips.values()]
      .filter((clip) => clip.status === ClipStatus.ACTIVE)
      .sort((left, right) => {
        const createdAtDiff =
          right.createdAt.getTime() - left.createdAt.getTime();
        return createdAtDiff || right.id.localeCompare(left.id);
      });
    const startIndex = input.cursor
      ? sortedClips.findIndex((clip) => clip.id === input.cursor) + 1
      : 0;

    return sortedClips.slice(Math.max(startIndex, 0), startIndex + input.limit);
  }

  async findClipLike(clipId: string, userId: string): Promise<boolean> {
    return this.likes.has(likeKey(clipId, userId));
  }

  async addClipLike(clipId: string, userId: string): Promise<boolean> {
    const key = likeKey(clipId, userId);

    if (this.likes.has(key)) {
      return false;
    }

    this.likes.add(key);
    return true;
  }

  async removeClipLike(clipId: string, userId: string): Promise<boolean> {
    return this.likes.delete(likeKey(clipId, userId));
  }

  async adjustClipLikes(
    clipId: string,
    delta: number
  ): Promise<ClipRecord | null> {
    const clip = this.clips.get(clipId);

    if (!clip) {
      return null;
    }

    const updatedClip = {
      ...clip,
      likesCount: Math.max(0, clip.likesCount + delta)
    };

    this.clips.set(clipId, updatedClip);
    return updatedClip;
  }

  async findUserFollow(
    followerId: string,
    followingId: string
  ): Promise<boolean> {
    return this.follows.has(followKey(followerId, followingId));
  }

  async addUserFollow(
    followerId: string,
    followingId: string
  ): Promise<boolean> {
    const key = followKey(followerId, followingId);

    if (this.follows.has(key)) {
      return false;
    }

    this.follows.add(key);
    return true;
  }

  async removeUserFollow(
    followerId: string,
    followingId: string
  ): Promise<boolean> {
    return this.follows.delete(followKey(followerId, followingId));
  }

  async incrementClipShares(clipId: string): Promise<ClipRecord | null> {
    const clip = this.clips.get(clipId);

    if (!clip) {
      return null;
    }

    const updatedClip = {
      ...clip,
      sharesCount: clip.sharesCount + 1
    };

    this.clips.set(clipId, updatedClip);
    return updatedClip;
  }
}

test('SocialClipsService creates a valid clip with metadata', async () => {
  const { service } = createFixture();

  const clip = await service.createClip('author_1', validClipInput());

  assert.equal(clip.authorId, 'author_1');
  assert.equal(clip.title, 'Perro aprende a usar su QR');
  assert.equal(clip.category, 'Consejos');
  assert.equal(clip.animalType, 'Perro');
  assert.equal(clip.videoUrl, 'mascotify://videos/perro-qr.mp4');
  assert.equal(clip.thumbnailUrl, 'assets/images/clips/perro-qr.png');
  assert.equal(clip.cloudinaryPublicId, null);
  assert.equal(clip.durationSeconds, 18);
  assert.equal(clip.likesCount, 0);
  assert.equal(clip.sharesCount, 0);
  assert.equal(clip.status, ClipStatus.ACTIVE);
});

test('SocialClipsService creates a clip with Cloudinary metadata', async () => {
  const { service } = createFixture();

  const clip = await service.createClip('author_1', {
    ...validClipInput(),
    videoUrl: 'https://res.cloudinary.com/demo/video/upload/v1/clip.mp4',
    thumbnailUrl: 'https://res.cloudinary.com/demo/video/upload/v1/clip.jpg',
    cloudinaryPublicId: 'mascotify/clips/clip'
  });

  assert.equal(
    clip.videoUrl,
    'https://res.cloudinary.com/demo/video/upload/v1/clip.mp4'
  );
  assert.equal(clip.cloudinaryPublicId, 'mascotify/clips/clip');

  const feed = await service.getFeed({ viewerId: 'viewer_1' });

  assert.equal(feed.items[0].id, clip.id);
  assert.equal(
    feed.items[0].videoUrl,
    'https://res.cloudinary.com/demo/video/upload/v1/clip.mp4'
  );
  assert.equal(feed.items[0].cloudinaryPublicId, 'mascotify/clips/clip');
});

test('SocialClipsService rejects a real uploaded clip without video url', async () => {
  const { service } = createFixture();

  await assert.rejects(
    () =>
      service.createClip('author_1', {
        ...validClipInput(),
        videoUrl: ' '
      }),
    /Clip data is invalid/
  );
});

test('SocialClipsService rejects invalid clip input with controlled error', async () => {
  const { service } = createFixture();

  await assert.rejects(
    () =>
      service.createClip('author_1', {
        ...validClipInput(),
        title: ' '
      }),
    /Clip data is invalid/
  );

  await assert.rejects(
    () =>
      service.createClip('author_1', {
        ...validClipInput(),
        durationSeconds: -3
      }),
    /Clip data is invalid/
  );
});

test('SocialClipsService feed returns recent active clips first', async () => {
  const { service } = createFixture();
  await service.createClip('author_1', {
    ...validClipInput(),
    title: 'Primer clip'
  });
  await service.createClip('author_2', {
    ...validClipInput(),
    title: 'Clip mas reciente'
  });

  const feed = await service.getFeed({ limit: 10 });

  assert.deepEqual(
    feed.items.map((clip) => clip.title),
    ['Clip mas reciente', 'Primer clip']
  );
  assert.equal(feed.pageInfo.hasNextPage, false);
});

test('SocialClipsService like increments count and marks state', async () => {
  const { service } = createFixture();
  const clip = await service.createClip('author_1', validClipInput());

  const likedClip = await service.likeClip(clip.id, 'viewer_1');

  assert.equal(likedClip.likesCount, 1);
  assert.equal(likedClip.isLiked, true);
});

test('SocialClipsService unlike reverts count and state', async () => {
  const { service } = createFixture();
  const clip = await service.createClip('author_1', validClipInput());
  await service.likeClip(clip.id, 'viewer_1');

  const unlikedClip = await service.unlikeClip(clip.id, 'viewer_1');

  assert.equal(unlikedClip.likesCount, 0);
  assert.equal(unlikedClip.isLiked, false);
});

test('SocialClipsService does not duplicate likes from the same user', async () => {
  const { service } = createFixture();
  const clip = await service.createClip('author_1', validClipInput());

  await service.likeClip(clip.id, 'viewer_1');
  const likedAgainClip = await service.likeClip(clip.id, 'viewer_1');

  assert.equal(likedAgainClip.likesCount, 1);
  assert.equal(likedAgainClip.isLiked, true);
});

test('SocialClipsService follow creates a relation', async () => {
  const { repository, service } = createFixture();

  const result = await service.followUser('viewer_1', 'author_1');

  assert.deepEqual(result, {
    followingId: 'author_1',
    isFollowing: true
  });
  assert.equal(repository.follows.has(followKey('viewer_1', 'author_1')), true);
});

test('SocialClipsService unfollow removes a relation', async () => {
  const { repository, service } = createFixture();
  await service.followUser('viewer_1', 'author_1');

  const result = await service.unfollowUser('viewer_1', 'author_1');

  assert.deepEqual(result, {
    followingId: 'author_1',
    isFollowing: false
  });
  assert.equal(repository.follows.has(followKey('viewer_1', 'author_1')), false);
});

test('SocialClipsService feed indicates isLiked for viewer', async () => {
  const { service } = createFixture();
  const clip = await service.createClip('author_1', validClipInput());
  await service.likeClip(clip.id, 'viewer_1');

  const feed = await service.getFeed({ viewerId: 'viewer_1' });

  assert.equal(feed.items[0].id, clip.id);
  assert.equal(feed.items[0].isLiked, true);
});

test('SocialClipsService feed indicates isFollowingAuthor for viewer', async () => {
  const { service } = createFixture();
  const clip = await service.createClip('author_1', validClipInput());
  await service.followUser('viewer_1', 'author_1');

  const feed = await service.getFeed({ viewerId: 'viewer_1' });

  assert.equal(feed.items[0].id, clip.id);
  assert.equal(feed.items[0].isFollowingAuthor, true);
});

test('SocialClipsService share increments count', async () => {
  const { service } = createFixture();
  const clip = await service.createClip('author_1', validClipInput());

  const sharedClip = await service.shareClip(clip.id, 'viewer_1');

  assert.equal(sharedClip.sharesCount, 1);
});

test('SocialClipsService excludes hidden and deleted clips from feed', async () => {
  const { service } = createFixture();
  const activeClip = await service.createClip('author_1', {
    ...validClipInput(),
    title: 'Clip activo'
  });
  const hiddenClip = await service.createClip('author_1', {
    ...validClipInput(),
    title: 'Clip oculto'
  });
  const deletedClip = await service.createClip('author_1', {
    ...validClipInput(),
    title: 'Clip eliminado'
  });
  await service.updateClip(hiddenClip.id, { status: ClipStatus.HIDDEN });
  await service.updateClip(deletedClip.id, { status: ClipStatus.DELETED });

  const feed = await service.getFeed({});

  assert.deepEqual(
    feed.items.map((clip) => clip.id),
    [activeClip.id]
  );
});

test('SocialClipsService gets a clip by id with expected metadata', async () => {
  const { service } = createFixture();
  const createdClip = await service.createClip('author_1', validClipInput());
  await service.likeClip(createdClip.id, 'viewer_1');
  await service.followUser('viewer_1', 'author_1');

  const clip = await service.getClipById(createdClip.id, 'viewer_1');

  assert.equal(clip.id, createdClip.id);
  assert.equal(clip.author.displayName, 'Creator author_1');
  assert.equal(clip.isLiked, true);
  assert.equal(clip.isFollowingAuthor, true);
  assert.equal(clip.likesCount, 1);
});

function createFixture(): {
  repository: FakeSocialClipsRepository;
  service: SocialClipsService;
} {
  const repository = new FakeSocialClipsRepository();
  return {
    repository,
    service: new SocialClipsService(repository)
  };
}

function validClipInput(): {
  title: string;
  description: string;
  animalType: string;
  category: string;
  videoUrl: string;
  thumbnailUrl: string;
  cloudinaryPublicId?: string;
  durationSeconds: number;
} {
  return {
    title: 'Perro aprende a usar su QR',
    description: 'Un clip demo listo para reemplazar con video propio.',
    animalType: 'Perro',
    category: 'Consejos',
    videoUrl: 'mascotify://videos/perro-qr.mp4',
    thumbnailUrl: 'assets/images/clips/perro-qr.png',
    durationSeconds: 18
  };
}

function makeAuthor(authorId: string): ClipAuthor {
  return {
    id: authorId,
    displayName: `Creator ${authorId}`,
    avatarUrl: null
  };
}

function likeKey(clipId: string, userId: string): string {
  return `${clipId}:${userId}`;
}

function followKey(followerId: string, followingId: string): string {
  return `${followerId}:${followingId}`;
}
