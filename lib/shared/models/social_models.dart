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

  MessageThread copyWith({
    String? id,
    String? ownerName,
    Pet? pet,
    String? relatedLabel,
    String? lastMessage,
    String? status,
    String? lastActivity,
    String? summary,
    int? accentColorHex,
    String? connectionType,
    String? stageLabel,
    String? entryPointLabel,
    String? nextStepLabel,
    List<String>? contextTags,
    int? unreadCount,
    bool? isAwaitingMyReply,
    List<String>? autoReplies,
    List<MessageEntry>? messages,
  }) {
    return MessageThread(
      id: id ?? this.id,
      ownerName: ownerName ?? this.ownerName,
      pet: pet ?? this.pet,
      relatedLabel: relatedLabel ?? this.relatedLabel,
      lastMessage: lastMessage ?? this.lastMessage,
      status: status ?? this.status,
      lastActivity: lastActivity ?? this.lastActivity,
      summary: summary ?? this.summary,
      accentColorHex: accentColorHex ?? this.accentColorHex,
      connectionType: connectionType ?? this.connectionType,
      stageLabel: stageLabel ?? this.stageLabel,
      entryPointLabel: entryPointLabel ?? this.entryPointLabel,
      nextStepLabel: nextStepLabel ?? this.nextStepLabel,
      contextTags: contextTags ?? this.contextTags,
      unreadCount: unreadCount ?? this.unreadCount,
      isAwaitingMyReply: isAwaitingMyReply ?? this.isAwaitingMyReply,
      autoReplies: autoReplies ?? this.autoReplies,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'ownerName': ownerName,
      'pet': pet.toJson(),
      'relatedLabel': relatedLabel,
      'lastMessage': lastMessage,
      'status': status,
      'lastActivity': lastActivity,
      'summary': summary,
      'accentColorHex': accentColorHex,
      'connectionType': connectionType,
      'stageLabel': stageLabel,
      'entryPointLabel': entryPointLabel,
      'nextStepLabel': nextStepLabel,
      'contextTags': contextTags,
      'unreadCount': unreadCount,
      'isAwaitingMyReply': isAwaitingMyReply,
      'autoReplies': autoReplies,
      'messages': messages.map((item) => item.toJson()).toList(),
    };
  }

  factory MessageThread.fromJson(Map<String, dynamic> json) {
    return MessageThread(
      id: json['id'] as String,
      ownerName: json['ownerName'] as String,
      pet: Pet.fromJson(Map<String, dynamic>.from(json['pet'] as Map)),
      relatedLabel: json['relatedLabel'] as String,
      lastMessage: json['lastMessage'] as String,
      status: json['status'] as String,
      lastActivity: json['lastActivity'] as String,
      summary: json['summary'] as String,
      accentColorHex: json['accentColorHex'] as int,
      connectionType: json['connectionType'] as String,
      stageLabel: json['stageLabel'] as String,
      entryPointLabel: json['entryPointLabel'] as String,
      nextStepLabel: json['nextStepLabel'] as String,
      contextTags: (json['contextTags'] as List<dynamic>)
          .map((item) => item as String)
          .toList(),
      unreadCount: json['unreadCount'] as int,
      isAwaitingMyReply: json['isAwaitingMyReply'] as bool,
      autoReplies: (json['autoReplies'] as List<dynamic>)
          .map((item) => item as String)
          .toList(),
      messages: (json['messages'] as List<dynamic>)
          .map(
            (item) => MessageEntry.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }
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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'text': text,
      'timestamp': timestamp,
      'isMine': isMine,
    };
  }

  factory MessageEntry.fromJson(Map<String, dynamic> json) {
    return MessageEntry(
      text: json['text'] as String,
      timestamp: json['timestamp'] as String,
      isMine: json['isMine'] as bool,
    );
  }
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

  SocialInboxEntry copyWith({
    Pet? pet,
    String? direction,
    String? interestType,
    String? status,
    String? message,
    int? accentColorHex,
  }) {
    return SocialInboxEntry(
      pet: pet ?? this.pet,
      direction: direction ?? this.direction,
      interestType: interestType ?? this.interestType,
      status: status ?? this.status,
      message: message ?? this.message,
      accentColorHex: accentColorHex ?? this.accentColorHex,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'pet': pet.toJson(),
      'direction': direction,
      'interestType': interestType,
      'status': status,
      'message': message,
      'accentColorHex': accentColorHex,
    };
  }

  factory SocialInboxEntry.fromJson(Map<String, dynamic> json) {
    return SocialInboxEntry(
      pet: Pet.fromJson(
        Map<String, dynamic>.from(json['pet'] as Map<dynamic, dynamic>),
      ),
      direction: json['direction'] as String,
      interestType: json['interestType'] as String,
      status: json['status'] as String,
      message: json['message'] as String,
      accentColorHex: json['accentColorHex'] as int,
    );
  }
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

  SavedProfileEntry copyWith({
    Pet? pet,
    String? savedAtLabel,
    String? reason,
  }) {
    return SavedProfileEntry(
      pet: pet ?? this.pet,
      savedAtLabel: savedAtLabel ?? this.savedAtLabel,
      reason: reason ?? this.reason,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'pet': pet.toJson(),
      'savedAtLabel': savedAtLabel,
      'reason': reason,
    };
  }

  factory SavedProfileEntry.fromJson(Map<String, dynamic> json) {
    return SavedProfileEntry(
      pet: Pet.fromJson(
        Map<String, dynamic>.from(json['pet'] as Map<dynamic, dynamic>),
      ),
      savedAtLabel: json['savedAtLabel'] as String,
      reason: json['reason'] as String,
    );
  }
}
