import assert from 'node:assert/strict';
import test from 'node:test';

import { UserRole } from '@prisma/client';

import { UsersService } from '../src/modules/users/users.service';
import type {
  NormalizedCreateUserInput,
  UsersRepositoryPort,
  UserWithProfiles
} from '../src/modules/users/users.types';

class FakeUsersRepository implements UsersRepositoryPort {
  readonly createdUsers: NormalizedCreateUserInput[] = [];
  readonly usersById = new Map<string, UserWithProfiles>();
  readonly usersByEmail = new Map<string, UserWithProfiles>();

  async findUserByEmail(email: string): Promise<UserWithProfiles | null> {
    return this.usersByEmail.get(email) ?? null;
  }

  async findUserById(id: string): Promise<UserWithProfiles | null> {
    return this.usersById.get(id) ?? null;
  }

  async createUser(input: NormalizedCreateUserInput): Promise<UserWithProfiles> {
    this.createdUsers.push(input);

    const now = new Date('2026-04-30T12:00:00.000Z');
    const id = `user_${this.createdUsers.length}`;
    const user: UserWithProfiles = {
      id,
      email: input.email,
      displayName: input.displayName,
      role: input.role,
      createdAt: now,
      updatedAt: now,
      deletedAt: null,
      profiles: [
        {
          id: `profile_${this.createdUsers.length}`,
          userId: id,
          profileType: input.profile.profileType,
          city: input.profile.city ?? null,
          phone: input.profile.phone ?? null,
          avatarUrl: input.profile.avatarUrl ?? null,
          createdAt: now,
          updatedAt: now
        }
      ]
    };

    this.usersById.set(user.id, user);
    this.usersByEmail.set(user.email, user);

    return user;
  }
}

test('UsersService creates a family user with normalized email and profile', async () => {
  const repository = new FakeUsersRepository();
  const service = new UsersService(repository);

  const user = await service.createUser({
    email: ' Familia@Mascotify.App ',
    displayName: ' Familia Demo ',
    profile: {
      city: ' Buenos Aires '
    }
  });

  assert.equal(user.email, 'familia@mascotify.app');
  assert.equal(user.displayName, 'Familia Demo');
  assert.equal(user.role, UserRole.FAMILY);
  assert.equal(user.profiles[0].profileType, UserRole.FAMILY);
  assert.equal(user.profiles[0].city, 'Buenos Aires');
  assert.deepEqual(repository.createdUsers[0], {
    email: 'familia@mascotify.app',
    displayName: 'Familia Demo',
    role: UserRole.FAMILY,
    profile: {
      profileType: UserRole.FAMILY,
      city: 'Buenos Aires',
      phone: undefined,
      avatarUrl: undefined
    }
  });
});

test('UsersService preserves professional role and normalizes lookup email', async () => {
  const repository = new FakeUsersRepository();
  const service = new UsersService(repository);

  const createdUser = await service.createUser({
    email: 'Pro@Mascotify.App',
    displayName: 'Profesional Demo',
    role: UserRole.PROFESSIONAL
  });

  const foundUser = await service.findUserByEmail(' pro@MASCOTIFY.app ');

  assert.equal(foundUser?.id, createdUser.id);
  assert.equal(foundUser?.role, UserRole.PROFESSIONAL);
  assert.equal(foundUser?.profiles[0].profileType, UserRole.PROFESSIONAL);
});

test('UsersService finds users by trimmed id', async () => {
  const repository = new FakeUsersRepository();
  const service = new UsersService(repository);
  const createdUser = await service.createUser({
    email: 'admin@mascotify.app',
    displayName: 'Admin Demo',
    role: UserRole.ADMIN
  });

  const foundUser = await service.findUserById(` ${createdUser.id} `);

  assert.equal(foundUser?.email, 'admin@mascotify.app');
  assert.equal(foundUser?.role, UserRole.ADMIN);
});

test('UsersService rejects empty user identity fields', async () => {
  const service = new UsersService(new FakeUsersRepository());

  await assert.rejects(
    () => service.createUser({ email: ' ', displayName: 'Familia Demo' }),
    /User email is required/
  );

  await assert.rejects(
    () => service.createUser({ email: 'user@mascotify.app', displayName: ' ' }),
    /User display name is required/
  );

  await assert.rejects(() => service.findUserById(' '), /User id is required/);
});
