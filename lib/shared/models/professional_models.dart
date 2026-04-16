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
