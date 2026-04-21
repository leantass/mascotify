import 'dart:convert';

import '../../../shared/models/account_identity_models.dart';
import '../../../shared/models/app_user.dart';

class LocalAuthSeedData {
  const LocalAuthSeedData._();

  static const String demoPassword = 'Mascotify123';
  static const String familyEmail = 'camila@mascotify.app';
  static const String professionalEmail = 'paula@mascotify.pro';
}

class StoredAuthSession {
  const StoredAuthSession({
    required this.userId,
    required this.activeExperience,
  });

  final String userId;
  final AccountExperience activeExperience;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'activeExperience': activeExperience.name,
    };
  }

  factory StoredAuthSession.fromJson(Map<String, dynamic> json) {
    return StoredAuthSession(
      userId: json['userId'] as String,
      activeExperience: accountExperienceFromName(
        json['activeExperience'] as String,
      ),
    );
  }
}

class StoredFamilyProfile {
  const StoredFamilyProfile({
    required this.householdName,
    required this.petsSummaryLabel,
    required this.primaryGoal,
    required this.nextSetupStep,
    required this.capabilities,
  });

  final String householdName;
  final String petsSummaryLabel;
  final String primaryGoal;
  final String nextSetupStep;
  final List<String> capabilities;

  FamilyAccountProfile toDomain() {
    return FamilyAccountProfile(
      householdName: householdName,
      petsSummaryLabel: petsSummaryLabel,
      primaryGoal: primaryGoal,
      nextSetupStep: nextSetupStep,
      capabilities: capabilities,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'householdName': householdName,
      'petsSummaryLabel': petsSummaryLabel,
      'primaryGoal': primaryGoal,
      'nextSetupStep': nextSetupStep,
      'capabilities': capabilities,
    };
  }

  factory StoredFamilyProfile.fromDomain(FamilyAccountProfile profile) {
    return StoredFamilyProfile(
      householdName: profile.householdName,
      petsSummaryLabel: profile.petsSummaryLabel,
      primaryGoal: profile.primaryGoal,
      nextSetupStep: profile.nextSetupStep,
      capabilities: List<String>.unmodifiable(profile.capabilities),
    );
  }

  factory StoredFamilyProfile.fromJson(Map<String, dynamic> json) {
    return StoredFamilyProfile(
      householdName: json['householdName'] as String,
      petsSummaryLabel: json['petsSummaryLabel'] as String,
      primaryGoal: json['primaryGoal'] as String,
      nextSetupStep: json['nextSetupStep'] as String,
      capabilities: (json['capabilities'] as List<dynamic>).cast<String>(),
    );
  }
}

class StoredProfessionalProfile {
  const StoredProfessionalProfile({
    required this.businessName,
    required this.category,
    required this.operationLabel,
    required this.primaryGoal,
    required this.nextSetupStep,
    required this.services,
    required this.capabilities,
  });

  final String businessName;
  final String category;
  final String operationLabel;
  final String primaryGoal;
  final String nextSetupStep;
  final List<String> services;
  final List<String> capabilities;

  ProfessionalAccountProfile toDomain() {
    return ProfessionalAccountProfile(
      businessName: businessName,
      category: category,
      operationLabel: operationLabel,
      primaryGoal: primaryGoal,
      nextSetupStep: nextSetupStep,
      services: services,
      capabilities: capabilities,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'businessName': businessName,
      'category': category,
      'operationLabel': operationLabel,
      'primaryGoal': primaryGoal,
      'nextSetupStep': nextSetupStep,
      'services': services,
      'capabilities': capabilities,
    };
  }

  factory StoredProfessionalProfile.fromDomain(
    ProfessionalAccountProfile profile,
  ) {
    return StoredProfessionalProfile(
      businessName: profile.businessName,
      category: profile.category,
      operationLabel: profile.operationLabel,
      primaryGoal: profile.primaryGoal,
      nextSetupStep: profile.nextSetupStep,
      services: List<String>.unmodifiable(profile.services),
      capabilities: List<String>.unmodifiable(profile.capabilities),
    );
  }

  factory StoredProfessionalProfile.fromJson(Map<String, dynamic> json) {
    return StoredProfessionalProfile(
      businessName: json['businessName'] as String,
      category: json['category'] as String,
      operationLabel: json['operationLabel'] as String,
      primaryGoal: json['primaryGoal'] as String,
      nextSetupStep: json['nextSetupStep'] as String,
      services: (json['services'] as List<dynamic>).cast<String>(),
      capabilities: (json['capabilities'] as List<dynamic>).cast<String>(),
    );
  }
}

class StoredAuthAccount {
  const StoredAuthAccount({
    required this.id,
    required this.ownerName,
    required this.email,
    required this.passwordHash,
    required this.planName,
    required this.city,
    required this.memberSince,
    required this.availableExperiences,
    required this.lastActiveExperience,
    required this.onboardingCompleted,
    this.familyProfile,
    this.professionalProfile,
  });

  final String id;
  final String ownerName;
  final String email;
  final String passwordHash;
  final String planName;
  final String city;
  final String memberSince;
  final List<AccountExperience> availableExperiences;
  final AccountExperience lastActiveExperience;
  final bool onboardingCompleted;
  final StoredFamilyProfile? familyProfile;
  final StoredProfessionalProfile? professionalProfile;

  bool supportsExperience(AccountExperience experience) {
    return availableExperiences.contains(experience);
  }

  StoredAuthAccount copyWith({
    String? id,
    String? ownerName,
    String? email,
    String? passwordHash,
    String? planName,
    String? city,
    String? memberSince,
    List<AccountExperience>? availableExperiences,
    AccountExperience? lastActiveExperience,
    bool? onboardingCompleted,
    StoredFamilyProfile? familyProfile,
    StoredProfessionalProfile? professionalProfile,
  }) {
    return StoredAuthAccount(
      id: id ?? this.id,
      ownerName: ownerName ?? this.ownerName,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      planName: planName ?? this.planName,
      city: city ?? this.city,
      memberSince: memberSince ?? this.memberSince,
      availableExperiences: availableExperiences ?? this.availableExperiences,
      lastActiveExperience: lastActiveExperience ?? this.lastActiveExperience,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      familyProfile: familyProfile ?? this.familyProfile,
      professionalProfile: professionalProfile ?? this.professionalProfile,
    );
  }

  AppUser toAppUser() {
    return AppUser(
      id: id,
      name: ownerName,
      email: email,
      planName: planName,
      city: city,
      memberSince: memberSince,
      notificationsEnabled: true,
    );
  }

  MascotifyAccount toMascotifyAccount() {
    return MascotifyAccount(
      id: id,
      ownerName: ownerName,
      email: email,
      planName: planName,
      city: city,
      memberSince: memberSince,
      baseSummary: _buildBaseSummary(),
      linkedProfilesSummary: _buildLinkedProfilesSummary(),
      availableExperiences: availableExperiences,
      familyProfile: familyProfile?.toDomain(),
      professionalProfile: professionalProfile?.toDomain(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'ownerName': ownerName,
      'email': email,
      'passwordHash': passwordHash,
      'planName': planName,
      'city': city,
      'memberSince': memberSince,
      'availableExperiences': availableExperiences
          .map((item) => item.name)
          .toList(),
      'lastActiveExperience': lastActiveExperience.name,
      'onboardingCompleted': onboardingCompleted,
      'familyProfile': familyProfile?.toJson(),
      'professionalProfile': professionalProfile?.toJson(),
    };
  }

  factory StoredAuthAccount.fromJson(Map<String, dynamic> json) {
    return StoredAuthAccount(
      id: json['id'] as String,
      ownerName: json['ownerName'] as String,
      email: json['email'] as String,
      passwordHash: json['passwordHash'] as String,
      planName: json['planName'] as String,
      city: json['city'] as String,
      memberSince: json['memberSince'] as String,
      availableExperiences: (json['availableExperiences'] as List<dynamic>)
          .cast<String>()
          .map(accountExperienceFromName)
          .toList(),
      lastActiveExperience: accountExperienceFromName(
        json['lastActiveExperience'] as String,
      ),
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
      familyProfile: json['familyProfile'] == null
          ? null
          : StoredFamilyProfile.fromJson(
              json['familyProfile'] as Map<String, dynamic>,
            ),
      professionalProfile: json['professionalProfile'] == null
          ? null
          : StoredProfessionalProfile.fromJson(
              json['professionalProfile'] as Map<String, dynamic>,
            ),
    );
  }

  String _buildBaseSummary() {
    return 'Cuenta base local y persistida para centralizar identidad, sesión y crecimiento por perfiles sin rehacer la arquitectura.';
  }

  String _buildLinkedProfilesSummary() {
    if (availableExperiences.length > 1) {
      return 'La misma cuenta ya puede recuperar y alternar entre familia y profesional dentro de una sola sesión.';
    }

    final target = availableExperiences.first == AccountExperience.family
        ? 'profesional'
        : 'familiar';
    return 'La cuenta arranca con un perfil activo, pero queda lista para sumar una capa $target más adelante sin duplicar identidad.';
  }
}

AccountExperience accountExperienceFromName(String rawValue) {
  return AccountExperience.values.firstWhere(
    (item) => item.name == rawValue,
    orElse: () => AccountExperience.family,
  );
}

String normalizeEmail(String value) {
  return value.trim().toLowerCase();
}

String hashPassword(String rawPassword) {
  const int offsetBasis = 0xcbf29ce484222325;
  const int prime = 0x100000001b3;
  final bytes = utf8.encode('mascotify-local-auth::$rawPassword');

  var hash = offsetBasis;
  for (final byte in bytes) {
    hash ^= byte;
    hash = (hash * prime) & 0xFFFFFFFFFFFFFFFF;
  }

  return hash.toRadixString(16).padLeft(16, '0');
}
