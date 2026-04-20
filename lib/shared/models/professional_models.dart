class ProfessionalProfile {
  const ProfessionalProfile({
    required this.name,
    required this.specialty,
    required this.biography,
    required this.description,
    required this.contentType,
    required this.valueProposition,
    required this.approachStyle,
    required this.helpSummary,
    required this.profileModeLabel,
    required this.presenceStatusLabel,
    required this.serviceAvailabilityLabel,
    required this.serviceSummary,
    required this.services,
    required this.trustSignals,
    required this.primaryActionLabel,
    required this.secondaryActionLabel,
    required this.topics,
    required this.featuredContent,
    required this.accentColorHex,
  });

  final String name;
  final String specialty;
  final String biography;
  final String description;
  final String contentType;
  final String valueProposition;
  final String approachStyle;
  final String helpSummary;
  final String profileModeLabel;
  final String presenceStatusLabel;
  final String serviceAvailabilityLabel;
  final String serviceSummary;
  final List<String> services;
  final List<String> trustSignals;
  final String primaryActionLabel;
  final String secondaryActionLabel;
  final List<String> topics;
  final List<ProfessionalContentPreview> featuredContent;
  final int accentColorHex;

  ProfessionalProfile copyWith({
    String? name,
    String? specialty,
    String? biography,
    String? description,
    String? contentType,
    String? valueProposition,
    String? approachStyle,
    String? helpSummary,
    String? profileModeLabel,
    String? presenceStatusLabel,
    String? serviceAvailabilityLabel,
    String? serviceSummary,
    List<String>? services,
    List<String>? trustSignals,
    String? primaryActionLabel,
    String? secondaryActionLabel,
    List<String>? topics,
    List<ProfessionalContentPreview>? featuredContent,
    int? accentColorHex,
  }) {
    return ProfessionalProfile(
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      biography: biography ?? this.biography,
      description: description ?? this.description,
      contentType: contentType ?? this.contentType,
      valueProposition: valueProposition ?? this.valueProposition,
      approachStyle: approachStyle ?? this.approachStyle,
      helpSummary: helpSummary ?? this.helpSummary,
      profileModeLabel: profileModeLabel ?? this.profileModeLabel,
      presenceStatusLabel: presenceStatusLabel ?? this.presenceStatusLabel,
      serviceAvailabilityLabel:
          serviceAvailabilityLabel ?? this.serviceAvailabilityLabel,
      serviceSummary: serviceSummary ?? this.serviceSummary,
      services: services ?? this.services,
      trustSignals: trustSignals ?? this.trustSignals,
      primaryActionLabel: primaryActionLabel ?? this.primaryActionLabel,
      secondaryActionLabel: secondaryActionLabel ?? this.secondaryActionLabel,
      topics: topics ?? this.topics,
      featuredContent: featuredContent ?? this.featuredContent,
      accentColorHex: accentColorHex ?? this.accentColorHex,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'specialty': specialty,
      'biography': biography,
      'description': description,
      'contentType': contentType,
      'valueProposition': valueProposition,
      'approachStyle': approachStyle,
      'helpSummary': helpSummary,
      'profileModeLabel': profileModeLabel,
      'presenceStatusLabel': presenceStatusLabel,
      'serviceAvailabilityLabel': serviceAvailabilityLabel,
      'serviceSummary': serviceSummary,
      'services': services,
      'trustSignals': trustSignals,
      'primaryActionLabel': primaryActionLabel,
      'secondaryActionLabel': secondaryActionLabel,
      'topics': topics,
      'featuredContent': featuredContent.map((item) => item.toJson()).toList(),
      'accentColorHex': accentColorHex,
    };
  }

  factory ProfessionalProfile.fromJson(Map<String, dynamic> json) {
    return ProfessionalProfile(
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      biography: json['biography'] as String,
      description: json['description'] as String,
      contentType: json['contentType'] as String,
      valueProposition: json['valueProposition'] as String,
      approachStyle: json['approachStyle'] as String,
      helpSummary: json['helpSummary'] as String,
      profileModeLabel: json['profileModeLabel'] as String,
      presenceStatusLabel: json['presenceStatusLabel'] as String,
      serviceAvailabilityLabel: json['serviceAvailabilityLabel'] as String,
      serviceSummary: json['serviceSummary'] as String,
      services: (json['services'] as List<dynamic>).cast<String>(),
      trustSignals: (json['trustSignals'] as List<dynamic>).cast<String>(),
      primaryActionLabel: json['primaryActionLabel'] as String,
      secondaryActionLabel: json['secondaryActionLabel'] as String,
      topics: (json['topics'] as List<dynamic>).cast<String>(),
      featuredContent: (json['featuredContent'] as List<dynamic>)
          .map(
            (item) => ProfessionalContentPreview.fromJson(
              Map<String, dynamic>.from(item as Map<dynamic, dynamic>),
            ),
          )
          .toList(),
      accentColorHex: json['accentColorHex'] as int,
    );
  }
}

class ProfessionalContentPreview {
  const ProfessionalContentPreview({
    required this.title,
    required this.category,
    required this.duration,
    required this.summary,
  });

  final String title;
  final String category;
  final String duration;
  final String summary;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'category': category,
      'duration': duration,
      'summary': summary,
    };
  }

  factory ProfessionalContentPreview.fromJson(Map<String, dynamic> json) {
    return ProfessionalContentPreview(
      title: json['title'] as String,
      category: json['category'] as String,
      duration: json['duration'] as String,
      summary: json['summary'] as String,
    );
  }
}

class ProfessionalLibraryContent {
  const ProfessionalLibraryContent({
    required this.title,
    required this.professional,
    required this.category,
    required this.duration,
    required this.summary,
    required this.accentColorHex,
  });

  final String title;
  final String professional;
  final String category;
  final String duration;
  final String summary;
  final int accentColorHex;
}

class ProfessionalRecommendation {
  const ProfessionalRecommendation({
    required this.title,
    required this.subtitle,
    required this.accentColorHex,
  });

  final String title;
  final String subtitle;
  final int accentColorHex;
}

class ProfessionalServiceSpotlight {
  const ProfessionalServiceSpotlight({
    required this.title,
    required this.subtitle,
    required this.availabilityLabel,
    required this.accentColorHex,
  });

  final String title;
  final String subtitle;
  final String availabilityLabel;
  final int accentColorHex;
}
