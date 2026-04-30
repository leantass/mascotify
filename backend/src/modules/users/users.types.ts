import type { User, UserProfile, UserRole } from '@prisma/client';

export type UserWithProfiles = User & {
  profiles: UserProfile[];
};

export type CreateUserInput = {
  email: string;
  displayName: string;
  role?: UserRole;
  profile?: {
    profileType?: UserRole;
    city?: string;
    phone?: string;
    avatarUrl?: string;
  };
};

export type NormalizedCreateUserInput = {
  email: string;
  displayName: string;
  role: UserRole;
  profile: {
    profileType: UserRole;
    city?: string;
    phone?: string;
    avatarUrl?: string;
  };
};

export type UsersRepositoryPort = {
  findUserByEmail(email: string): Promise<UserWithProfiles | null>;
  findUserById(id: string): Promise<UserWithProfiles | null>;
  createUser(input: NormalizedCreateUserInput): Promise<UserWithProfiles>;
};
