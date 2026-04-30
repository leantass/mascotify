import type { PrismaClient } from '@prisma/client';

import { prisma } from '../../shared/database/prisma';
import type {
  NormalizedCreateUserInput,
  UsersRepositoryPort,
  UserWithProfiles
} from './users.types';

const userWithProfiles = {
  profiles: true
};

export class PrismaUsersRepository implements UsersRepositoryPort {
  constructor(private readonly client: PrismaClient = prisma) {}

  findUserByEmail(email: string): Promise<UserWithProfiles | null> {
    return this.client.user.findUnique({
      where: { email },
      include: userWithProfiles
    });
  }

  findUserById(id: string): Promise<UserWithProfiles | null> {
    return this.client.user.findUnique({
      where: { id },
      include: userWithProfiles
    });
  }

  createUser(input: NormalizedCreateUserInput): Promise<UserWithProfiles> {
    return this.client.user.create({
      data: {
        email: input.email,
        displayName: input.displayName,
        role: input.role,
        profiles: {
          create: {
            profileType: input.profile.profileType,
            city: input.profile.city,
            phone: input.profile.phone,
            avatarUrl: input.profile.avatarUrl
          }
        }
      },
      include: userWithProfiles
    });
  }
}
