class Pet {
  const Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.ageLabel,
    required this.status,
    required this.colorHex,
    required this.profileId,
    required this.identitySummary,
    required this.documentStatus,
    required this.qrStatus,
    required this.healthSummary,
    required this.quickActions,
    required this.qrCodeLabel,
    required this.qrEnabled,
    required this.qrLastUpdate,
    required this.qrPrimaryAction,
    required this.qrSecondaryAction,
    required this.sex,
    required this.location,
    required this.biography,
    required this.personalityTags,
    required this.seekingBreeding,
    required this.socialInterest,
    required this.socialProfileStatus,
    required this.featuredMoments,
    required this.matchingPreferences,
  });

  final String id;
  final String name;
  final String species;
  final String breed;
  final String ageLabel;
  final String status;
  final int colorHex;
  final String profileId;
  final String identitySummary;
  final String documentStatus;
  final String qrStatus;
  final String healthSummary;
  final List<String> quickActions;
  final String qrCodeLabel;
  final bool qrEnabled;
  final String qrLastUpdate;
  final String qrPrimaryAction;
  final String qrSecondaryAction;
  final String sex;
  final String location;
  final String biography;
  final List<String> personalityTags;
  final bool seekingBreeding;
  final String socialInterest;
  final String socialProfileStatus;
  final List<String> featuredMoments;
  final PetMatchingPreferences matchingPreferences;
}

class PetMatchingPreferences {
  const PetMatchingPreferences({
    required this.preferredBondType,
    required this.locationRadiusLabel,
    required this.acceptsGradualMeet,
    required this.desiredCompatibilities,
    required this.idealContext,
    required this.importantNotes,
  });

  final String preferredBondType;
  final String locationRadiusLabel;
  final bool acceptsGradualMeet;
  final List<String> desiredCompatibilities;
  final String idealContext;
  final String importantNotes;
}
