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
  final String? professionalName;
  final String? contentTitle;
}
