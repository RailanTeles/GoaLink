class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
  });

  final String text;
  final bool isMe;
  final DateTime timestamp;
}