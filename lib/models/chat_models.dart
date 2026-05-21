import 'package:flutter/foundation.dart';

/// 聊天消息角色枚举。
///
/// 定义消息的发送者角色：
/// - [user]: 用户发送的消息
/// - [assistant]: AI 助手发送的消息
enum ChatRole {
  /// 用户角色，表示消息由用户发送
  user,

  /// 助手角色，表示消息由 AI 助手生成
  assistant,
}

/// 聊天消息状态枚举。
///
/// 定义消息的当前处理状态：
/// - [complete]: 消息已完成（发送成功或生成完成）
/// - [generating]: 消息正在生成中（AI 正在回复）
/// - [error]: 消息处理出错
enum ChatMessageStatus {
  /// 完成状态，消息已成功处理
  complete,

  /// 生成中状态，AI 正在生成回复
  generating,

  /// 错误状态，消息处理失败
  error,
}

/// 聊天消息数据模型。
///
/// 表示单条聊天消息，包含消息内容、角色、状态等信息。
/// 使用 @immutable 标记，确保实例不可变。
@immutable
class ChatMessage {
  /// 创建聊天消息实例。
  ///
  /// [id] 消息唯一标识符
  /// [role] 消息角色（用户或助手）
  /// [content] 消息文本内容
  /// [createdAt] 消息创建时间
  /// [status] 消息状态，默认为完成状态
  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.status = ChatMessageStatus.complete,
  });

  /// 消息唯一标识符
  /// 格式：时间戳-序列号
  final String id;

  /// 消息角色
  /// 用于区分是用户消息还是 AI 助手消息
  final ChatRole role;

  /// 消息文本内容
  final String content;

  /// 消息创建时间
  final DateTime createdAt;

  /// 消息当前状态
  final ChatMessageStatus status;

  /// 判断消息是否为当前用户发送。
  ///
  /// 返回 true 表示这是用户发送的消息
  bool get isMine => role == ChatRole.user;

  /// 创建消息副本。
  ///
  /// 用于更新消息的部分属性，返回新的消息实例。
  ///
  /// [id] 新的消息 ID，不传则保持原值
  /// [role] 新的角色，不传则保持原值
  /// [content] 新的内容，不传则保持原值
  /// [createdAt] 新的创建时间，不传则保持原值
  /// [status] 新的状态，不传则保持原值
  ///
  /// 返回新的 ChatMessage 实例
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

/// 生成新的聊天消息 ID。
///
/// ID 格式：`时间戳-序列号`
/// 时间戳：当前时间的微秒数
/// 序列号：0-999999 循环递增
///
/// 返回唯一的消息 ID 字符串
String newChatMessageId() {
  /// 获取当前时间的微秒数作为时间戳
  final ts = DateTime.now().microsecondsSinceEpoch;

  /// 序列号递增并循环（0-999999）
  _chatMessageSeq = (_chatMessageSeq + 1) % 1000000;

  /// 返回组合后的 ID
  return '$ts-$_chatMessageSeq';
}

/// 消息序列号，用于生成唯一 ID
/// 范围：0-999999，循环使用
int _chatMessageSeq = 0;
