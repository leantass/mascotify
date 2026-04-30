import { UserRole } from '@prisma/client';

import { PrismaUsersRepository } from './users.repository';
import type {
  CreateUserInput,
  NormalizedCreateUserInput,
  UsersRepositoryPort,
  UserWithProfiles
} from './users.types';

export class UsersService {
  constructor(
    private readonly usersRepository: UsersRepositoryPort = new PrismaUsersRepository()
  ) {}

  findUserByEmail(email: string): Promise<UserWithProfiles | null> {
    return this.usersRepository.findUserByEmail(normalizeEmail(email));
  }

  async findUserById(id: string): Promise<UserWithProfiles | null> {
    const normalizedId = id.trim();

    if (!normalizedId) {
      throw new Error('User id is required.');
    }

    return this.usersRepository.findUserById(normalizedId);
  }

  async createUser(input: CreateUserInput): Promise<UserWithProfiles> {
    const normalizedInput = normalizeCreateUserInput(input);
    return this.usersRepository.createUser(normalizedInput);
  }
}

export function normalizeCreateUserInput(
  input: CreateUserInput
): NormalizedCreateUserInput {
  const email = normalizeEmail(input.email);
  const displayName = input.displayName.trim();
  const role = input.role ?? UserRole.FAMILY;
  const profileType = input.profile?.profileType ?? role;

  if (!email) {
    throw new Error('User email is required.');
  }

  if (!displayName) {
    throw new Error('User display name is required.');
  }

  return {
    email,
    displayName,
    role,
    profile: {
      profileType,
      city: normalizeOptionalText(input.profile?.city),
      phone: normalizeOptionalText(input.profile?.phone),
      avatarUrl: normalizeOptionalText(input.profile?.avatarUrl)
    }
  };
}

function normalizeEmail(email: string): string {
  return email.trim().toLowerCase();
}

function normalizeOptionalText(value: string | undefined): string | undefined {
  const normalizedValue = value?.trim();
  return normalizedValue ? normalizedValue : undefined;
}
