enum PetActivityEventType {
  created,
  updated,
  socialInterest,
  message,
  notification,
  qr,
  deleted,
}

class PetActivityEvent {
  const PetActivityEvent({
    required this.id,
    required this.petId,
    required this.accountId,
    required this.type,
    required this.title,
    required this.description,
    required this.createdAt,
    this.relatedEntityId,
    this.relatedEntityType,
  });

  final String id;
  final String petId;
  final String accountId;
  final PetActivityEventType type;
  final String title;
  final String description;
  final DateTime createdAt;
  final String? relatedEntityId;
  final String? relatedEntityType;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'petId': petId,
      'accountId': accountId,
      'type': type.name,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'relatedEntityId': relatedEntityId,
      'relatedEntityType': relatedEntityType,
    };
  }

  factory PetActivityEvent.fromJson(Map<String, dynamic> json) {
    return PetActivityEvent(
      id: json['id'] as String,
      petId: json['petId'] as String,
      accountId: json['accountId'] as String,
      type: PetActivityEventType.values.firstWhere(
        (value) => value.name == json['type'],
        orElse: () => PetActivityEventType.notification,
      ),
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      relatedEntityId: json['relatedEntityId'] as String?,
      relatedEntityType: json['relatedEntityType'] as String?,
    );
  }
}
