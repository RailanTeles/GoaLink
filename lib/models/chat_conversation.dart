import 'package:goalink/models/chat_message.dart';

class ChatConversation {
  const ChatConversation({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.timeLabel,
    required this.avatarLabel,
    required this.messages,
  });

  final String id;
  final String name;
  final String lastMessage;
  final String timeLabel;
  final String avatarLabel;
  final List<ChatMessage> messages;

  ChatConversation copyWith({
    String? id,
    String? name,
    String? lastMessage,
    String? timeLabel,
    String? avatarLabel,
    List<ChatMessage>? messages,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      timeLabel: timeLabel ?? this.timeLabel,
      avatarLabel: avatarLabel ?? this.avatarLabel,
      messages: messages ?? this.messages,
    );
  }
}
