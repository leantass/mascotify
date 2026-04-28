enum EcosystemNotificationType {
  socialInterest,
  message,
  qrReport,
  professionalContent,
  reminder,
}

enum EcosystemNotificationPriority { attention, useful, info }

enum EcosystemNotificationAction {
  openConnectionsInbox,
  openMessagesInbox,
  openPetDetail,
  openPetQrTraceability,
  openProfessionals,
  openProfessionalContent,
}

class EcosystemNotification {
  const EcosystemNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timeLabel,
    required this.accentColorHex,
    required this.priority,
    this.isUnread = false,
    this.isDismissible = true,
    this.actionLabel,
    this.action,
    this.petId,
    this.threadId,
    this.professionalName,
    this.contentTitle,
  });

  final String id;
  final EcosystemNotificationType type;
  final String title;
  final String description;
  final String timeLabel;
  final int accentColorHex;
  final EcosystemNotificationPriority priority;
  final bool isUnread;
  final bool isDismissible;
  final String? actionLabel;
  final EcosystemNotificationAction? action;
  final String? petId;
  final String? threadId;
  final String? professionalName;
  final String? contentTitle;

  EcosystemNotification copyWith({
    String? id,
    EcosystemNotificationType? type,
    String? title,
    String? description,
    String? timeLabel,
    int? accentColorHex,
    EcosystemNotificationPriority? priority,
    bool? isUnread,
    bool? isDismissible,
    String? actionLabel,
    EcosystemNotificationAction? action,
    String? petId,
    String? threadId,
    String? professionalName,
    String? contentTitle,
  }) {
    return EcosystemNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      timeLabel: timeLabel ?? this.timeLabel,
      accentColorHex: accentColorHex ?? this.accentColorHex,
      priority: priority ?? this.priority,
      isUnread: isUnread ?? this.isUnread,
      isDismissible: isDismissible ?? this.isDismissible,
      actionLabel: actionLabel ?? this.actionLabel,
      action: action ?? this.action,
      petId: petId ?? this.petId,
      threadId: threadId ?? this.threadId,
      professionalName: professionalName ?? this.professionalName,
      contentTitle: contentTitle ?? this.contentTitle,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'type': type.name,
      'title': title,
      'description': description,
      'timeLabel': timeLabel,
      'accentColorHex': accentColorHex,
      'priority': priority.name,
      'isUnread': isUnread,
      'isDismissible': isDismissible,
      'actionLabel': actionLabel,
      'action': action?.name,
      'petId': petId,
      'threadId': threadId,
      'professionalName': professionalName,
      'contentTitle': contentTitle,
    };
  }

  factory EcosystemNotification.fromJson(Map<String, dynamic> json) {
    return EcosystemNotification(
      id: json['id'] as String,
      type: _enumValue(
        EcosystemNotificationType.values,
        json['type'] as String?,
        EcosystemNotificationType.reminder,
      ),
      title: json['title'] as String,
      description: json['description'] as String,
      timeLabel: json['timeLabel'] as String? ?? 'Hoy',
      accentColorHex: json['accentColorHex'] as int? ?? 0xFFDDF6F6,
      priority: _enumValue(
        EcosystemNotificationPriority.values,
        json['priority'] as String?,
        EcosystemNotificationPriority.info,
      ),
      isUnread: json['isUnread'] as bool? ?? false,
      isDismissible: json['isDismissible'] as bool? ?? true,
      actionLabel: json['actionLabel'] as String?,
      action: json['action'] == null
          ? null
          : _enumValue(
              EcosystemNotificationAction.values,
              json['action'] as String?,
              EcosystemNotificationAction.openConnectionsInbox,
            ),
      petId: json['petId'] as String?,
      threadId: json['threadId'] as String?,
      professionalName: json['professionalName'] as String?,
      contentTitle: json['contentTitle'] as String?,
    );
  }
}

T _enumValue<T extends Enum>(List<T> values, String? name, T fallback) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  return fallback;
}
