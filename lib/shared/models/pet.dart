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
    this.country = '',
    this.region = '',
    this.city = '',
    this.locationFreeText = '',
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
  final String country;
  final String region;
  final String city;
  final String locationFreeText;
  final String biography;
  final List<String> personalityTags;
  final bool seekingBreeding;
  final String socialInterest;
  final String socialProfileStatus;
  final List<String> featuredMoments;
  final PetMatchingPreferences matchingPreferences;

  Pet copyWith({
    String? id,
    String? name,
    String? species,
    String? breed,
    String? ageLabel,
    String? status,
    int? colorHex,
    String? profileId,
    String? identitySummary,
    String? documentStatus,
    String? qrStatus,
    String? healthSummary,
    List<String>? quickActions,
    String? qrCodeLabel,
    bool? qrEnabled,
    String? qrLastUpdate,
    String? qrPrimaryAction,
    String? qrSecondaryAction,
    String? sex,
    String? location,
    String? country,
    String? region,
    String? city,
    String? locationFreeText,
    String? biography,
    List<String>? personalityTags,
    bool? seekingBreeding,
    String? socialInterest,
    String? socialProfileStatus,
    List<String>? featuredMoments,
    PetMatchingPreferences? matchingPreferences,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      ageLabel: ageLabel ?? this.ageLabel,
      status: status ?? this.status,
      colorHex: colorHex ?? this.colorHex,
      profileId: profileId ?? this.profileId,
      identitySummary: identitySummary ?? this.identitySummary,
      documentStatus: documentStatus ?? this.documentStatus,
      qrStatus: qrStatus ?? this.qrStatus,
      healthSummary: healthSummary ?? this.healthSummary,
      quickActions: quickActions ?? this.quickActions,
      qrCodeLabel: qrCodeLabel ?? this.qrCodeLabel,
      qrEnabled: qrEnabled ?? this.qrEnabled,
      qrLastUpdate: qrLastUpdate ?? this.qrLastUpdate,
      qrPrimaryAction: qrPrimaryAction ?? this.qrPrimaryAction,
      qrSecondaryAction: qrSecondaryAction ?? this.qrSecondaryAction,
      sex: sex ?? this.sex,
      location: location ?? this.location,
      country: country ?? this.country,
      region: region ?? this.region,
      city: city ?? this.city,
      locationFreeText: locationFreeText ?? this.locationFreeText,
      biography: biography ?? this.biography,
      personalityTags: personalityTags ?? this.personalityTags,
      seekingBreeding: seekingBreeding ?? this.seekingBreeding,
      socialInterest: socialInterest ?? this.socialInterest,
      socialProfileStatus: socialProfileStatus ?? this.socialProfileStatus,
      featuredMoments: featuredMoments ?? this.featuredMoments,
      matchingPreferences: matchingPreferences ?? this.matchingPreferences,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'species': species,
      'breed': breed,
      'ageLabel': ageLabel,
      'status': status,
      'colorHex': colorHex,
      'profileId': profileId,
      'identitySummary': identitySummary,
      'documentStatus': documentStatus,
      'qrStatus': qrStatus,
      'healthSummary': healthSummary,
      'quickActions': quickActions,
      'qrCodeLabel': qrCodeLabel,
      'qrEnabled': qrEnabled,
      'qrLastUpdate': qrLastUpdate,
      'qrPrimaryAction': qrPrimaryAction,
      'qrSecondaryAction': qrSecondaryAction,
      'sex': sex,
      'location': location,
      'country': country,
      'region': region,
      'city': city,
      'locationFreeText': locationFreeText,
      'biography': biography,
      'personalityTags': personalityTags,
      'seekingBreeding': seekingBreeding,
      'socialInterest': socialInterest,
      'socialProfileStatus': socialProfileStatus,
      'featuredMoments': featuredMoments,
      'matchingPreferences': matchingPreferences.toJson(),
    };
  }

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] as String,
      name: json['name'] as String,
      species: json['species'] as String,
      breed: json['breed'] as String,
      ageLabel: json['ageLabel'] as String,
      status: json['status'] as String,
      colorHex: json['colorHex'] as int,
      profileId: json['profileId'] as String,
      identitySummary: json['identitySummary'] as String,
      documentStatus: json['documentStatus'] as String,
      qrStatus: json['qrStatus'] as String,
      healthSummary: json['healthSummary'] as String,
      quickActions: (json['quickActions'] as List<dynamic>).cast<String>(),
      qrCodeLabel: json['qrCodeLabel'] as String,
      qrEnabled: json['qrEnabled'] as bool,
      qrLastUpdate: json['qrLastUpdate'] as String,
      qrPrimaryAction: json['qrPrimaryAction'] as String,
      qrSecondaryAction: json['qrSecondaryAction'] as String,
      sex: json['sex'] as String,
      location: json['location'] as String,
      country: json['country'] as String? ?? '',
      region: json['region'] as String? ?? '',
      city: json['city'] as String? ?? '',
      locationFreeText: json['locationFreeText'] as String? ?? '',
      biography: json['biography'] as String,
      personalityTags: (json['personalityTags'] as List<dynamic>)
          .cast<String>(),
      seekingBreeding: json['seekingBreeding'] as bool,
      socialInterest: json['socialInterest'] as String,
      socialProfileStatus: json['socialProfileStatus'] as String,
      featuredMoments: (json['featuredMoments'] as List<dynamic>)
          .cast<String>(),
      matchingPreferences: PetMatchingPreferences.fromJson(
        Map<String, dynamic>.from(
          json['matchingPreferences'] as Map<dynamic, dynamic>,
        ),
      ),
    );
  }
}

class PetMatchingPreferences {
  const PetMatchingPreferences({
    required this.preferredBondType,
    required this.matchSummary,
    required this.rhythmLabel,
    required this.locationRadiusLabel,
    required this.acceptsGradualMeet,
    required this.compatibilitySignals,
    required this.desiredCompatibilities,
    required this.softLimits,
    required this.idealContext,
    required this.importantNotes,
    required this.suggestedApproach,
  });

  final String preferredBondType;
  final String matchSummary;
  final String rhythmLabel;
  final String locationRadiusLabel;
  final bool acceptsGradualMeet;
  final List<String> compatibilitySignals;
  final List<String> desiredCompatibilities;
  final List<String> softLimits;
  final String idealContext;
  final String importantNotes;
  final String suggestedApproach;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'preferredBondType': preferredBondType,
      'matchSummary': matchSummary,
      'rhythmLabel': rhythmLabel,
      'locationRadiusLabel': locationRadiusLabel,
      'acceptsGradualMeet': acceptsGradualMeet,
      'compatibilitySignals': compatibilitySignals,
      'desiredCompatibilities': desiredCompatibilities,
      'softLimits': softLimits,
      'idealContext': idealContext,
      'importantNotes': importantNotes,
      'suggestedApproach': suggestedApproach,
    };
  }

  factory PetMatchingPreferences.fromJson(Map<String, dynamic> json) {
    return PetMatchingPreferences(
      preferredBondType: json['preferredBondType'] as String,
      matchSummary: json['matchSummary'] as String,
      rhythmLabel: json['rhythmLabel'] as String,
      locationRadiusLabel: json['locationRadiusLabel'] as String,
      acceptsGradualMeet: json['acceptsGradualMeet'] as bool,
      compatibilitySignals: (json['compatibilitySignals'] as List<dynamic>)
          .cast<String>(),
      desiredCompatibilities: (json['desiredCompatibilities'] as List<dynamic>)
          .cast<String>(),
      softLimits: (json['softLimits'] as List<dynamic>).cast<String>(),
      idealContext: json['idealContext'] as String,
      importantNotes: json['importantNotes'] as String,
      suggestedApproach: json['suggestedApproach'] as String,
    );
  }
}
