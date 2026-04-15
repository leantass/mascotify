class SightingLocationReference {
  const SightingLocationReference({
    required this.zone,
    required this.zoneReference,
    required this.shortReference,
    required this.timeReference,
    required this.mapLabelTop,
    required this.mapLabelBottom,
    required this.horizontalFactor,
    required this.verticalFactor,
  });

  final String zone;
  final String zoneReference;
  final String shortReference;
  final String timeReference;
  final String mapLabelTop;
  final String mapLabelBottom;
  final double horizontalFactor;
  final double verticalFactor;
}

class SightingReportDraft {
  const SightingReportDraft({
    required this.petId,
    required this.locationLabel,
    required this.notes,
    required this.condition,
    required this.allowContact,
  });

  final String petId;
  final String locationLabel;
  final String notes;
  final String condition;
  final bool allowContact;
}
