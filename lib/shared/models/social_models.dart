import 'pet.dart';

class MessageThread {
  const MessageThread({
    required this.id,
    required this.ownerName,
    required this.pet,
    required this.relatedLabel,
    required this.lastMessage,
    required this.status,
    required this.lastActivity,
    required this.summary,
    required this.accentColorHex,
    required this.connectionType,
    required this.stageLabel,
    required this.entryPointLabel,
    required this.nextStepLabel,
    required this.contextTags,
    required this.unreadCount,
    required this.isAwaitingMyReply,
    required this.autoReplies,
    required this.messages,
  });

  final String id;
  final String ownerName;
  final Pet pet;
  final String relatedLabel;
  final String lastMessage;
  final String status;
  final String lastActivity;
  final String summary;
  final int accentColorHex;
  final String connectionType;
  final String stageLabel;
  final String entryPointLabel;
  final String nextStepLabel;
  final List<String> contextTags;
  final int unreadCount;
  final bool isAwaitingMyReply;
  final List<String> autoReplies;
  final List<MessageEntry> messages;
}

class MessageEntry {
  const MessageEntry({
    required this.text,
    required this.timestamp,
    required this.isMine,
  });

  final String text;
  final String timestamp;
  final bool isMine;
}

class SocialInboxEntry {
  const SocialInboxEntry({
    required this.pet,
    required this.direction,
    required this.interestType,
    required this.status,
    required this.message,
    required this.accentColorHex,
  });

  final Pet pet;
  final String direction;
  final String interestType;
  final String status;
  final String message;
  final int accentColorHex;
}

class SavedProfileEntry {
  const SavedProfileEntry({
    required this.pet,
    required this.savedAtLabel,
    required this.reason,
  });

  final Pet pet;
  final String savedAtLabel;
  final String reason;
}
