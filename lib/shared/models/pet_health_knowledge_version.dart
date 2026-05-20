class PetHealthKnowledgeVersion {
  const PetHealthKnowledgeVersion({
    required this.version,
    required this.publishedAt,
    required this.region,
    required this.sourceSummary,
    required this.reviewedBy,
    required this.isLocalDemo,
    required this.disclaimer,
  });

  final String version;
  final DateTime publishedAt;
  final String region;
  final String sourceSummary;
  final String reviewedBy;
  final bool isLocalDemo;
  final String disclaimer;
}
