enum AccountExperience { family, professional }

class MascotifyAccount {
  const MascotifyAccount({
    required this.id,
    required this.ownerName,
    required this.email,
    required this.planName,
    required this.city,
    required this.memberSince,
    required this.baseSummary,
    required this.linkedProfilesSummary,
    required this.availableExperiences,
    this.familyProfile,
    this.professionalProfile,
  });

  final String id;
  final String ownerName;
  final String email;
  final String planName;
  final String city;
  final String memberSince;
  final String baseSummary;
  final String linkedProfilesSummary;
  final List<AccountExperience> availableExperiences;
  final FamilyAccountProfile? familyProfile;
  final ProfessionalAccountProfile? professionalProfile;
}

class FamilyAccountProfile {
  const FamilyAccountProfile({
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
}

class ProfessionalAccountProfile {
  const ProfessionalAccountProfile({
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
}

class ExperienceOption {
  const ExperienceOption({
    required this.experience,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.ctaLabel,
    required this.accentColorHex,
    required this.highlights,
    required this.futureHint,
  });

  final AccountExperience experience;
  final String title;
  final String subtitle;
  final String description;
  final String ctaLabel;
  final int accentColorHex;
  final List<String> highlights;
  final String futureHint;
}

class OnboardingTrack {
  const OnboardingTrack({
    required this.experience,
    required this.title,
    required this.subtitle,
    required this.architectureNote,
    required this.ctaLabel,
    required this.steps,
    required this.supportingHighlights,
  });

  final AccountExperience experience;
  final String title;
  final String subtitle;
  final String architectureNote;
  final String ctaLabel;
  final List<OnboardingStepPreview> steps;
  final List<String> supportingHighlights;
}

class OnboardingStepPreview {
  const OnboardingStepPreview({required this.title, required this.description});

  final String title;
  final String description;
}
