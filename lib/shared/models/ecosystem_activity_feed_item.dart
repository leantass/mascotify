enum EcosystemActivityFeedType {
  pet,
  qr,
  social,
  message,
  notification,
  professional,
}

class EcosystemActivityFeedItem {
  const EcosystemActivityFeedItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timeLabel,
    required this.sourceLabel,
    required this.sortValue,
    this.petId,
    this.threadId,
    this.notificationId,
    this.relatedEntityId,
    this.relatedEntityType,
  });

  final String id;
  final String title;
  final String description;
  final EcosystemActivityFeedType type;
  final String timeLabel;
  final String sourceLabel;
  final int sortValue;
  final String? petId;
  final String? threadId;
  final String? notificationId;
  final String? relatedEntityId;
  final String? relatedEntityType;

  bool get hasDestination => petId != null || threadId != null;
}
