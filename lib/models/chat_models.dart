import 'package:flutter/foundation.dart';

enum ChatRole { user, assistant }

enum ChatMessageStatus { complete, generating, error }

@immutable
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.status = ChatMessageStatus.complete,
  });

  final String id;
  final ChatRole role;
  final String content;
  final DateTime createdAt;
  final ChatMessageStatus status;

  bool get isMine => role == ChatRole.user;

  ChatMessage copyWith({
    String? id,
    ChatRole? role,
    String? content,
    DateTime? createdAt,
    ChatMessageStatus? status,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}

String newChatMessageId() {
  final ts = DateTime.now().microsecondsSinceEpoch;
  _chatMessageSeq = (_chatMessageSeq + 1) % 1000000;
  return '$ts-$_chatMessageSeq';
}

int _chatMessageSeq = 0;

