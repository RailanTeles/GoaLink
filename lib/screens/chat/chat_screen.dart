import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

class ChatStore {
  ChatStore._();

  static final ValueNotifier<List<ChatConversation>> conversations =
      ValueNotifier<List<ChatConversation>>(ChatScreen._initialConversations);

  static ChatConversation getConversation(String chatId) {
    return conversations.value.firstWhere((chat) => chat.id == chatId);
  }

  static void addMessage(String chatId, ChatMessage message) {
    final updated = [...conversations.value];
    final chatIndex = updated.indexWhere((chat) => chat.id == chatId);

    if (chatIndex == -1) {
      return;
    }

    final currentChat = updated[chatIndex];
    final updatedMessages = [...currentChat.messages, message];

    updated[chatIndex] = currentChat.copyWith(
      lastMessage: message.text,
      timeLabel: _formatTime(message.timestamp),
      messages: updatedMessages,
    );

    updated.sort((a, b) {
      final aTimestamp = a.messages.last.timestamp;
      final bTimestamp = b.messages.last.timestamp;
      return bTimestamp.compareTo(aTimestamp);
    });

    conversations.value = updated;
  }

  static String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  static const Color _cardColor = Color(0xFFB7C9BD);
  static const Color _darkGreen = Color(0xFF1B5E20);
  static const Color _screenBackground = Color(0xFFF4F4F2);

  static final List<ChatConversation> _initialConversations = [
    ChatConversation(
      id: 'clube-fofinho',
      name: 'Clube Fofinho',
      lastMessage: 'Pelo visto joga em qual posição?',
      timeLabel: '14:32',
      avatarLabel: 'CF',
      messages: [
        ChatMessage(
          text: 'Boa noite, craque!',
          isMe: false,
          timestamp: DateTime(2026, 3, 28, 20, 10),
        ),
        ChatMessage(
          text: 'Fala, tudo bem em que posso ajudar?',
          isMe: false,
          timestamp: DateTime(2026, 3, 28, 20, 11),
        ),
        ChatMessage(
          text: 'Sou goleiro playboy',
          isMe: true,
          timestamp: DateTime(2026, 3, 28, 20, 12),
        ),
        ChatMessage(
          text: 'Pelo visto joga em qual posição?',
          isMe: false,
          timestamp: DateTime(2026, 3, 28, 20, 13),
        ),
      ],
    ),
    ChatConversation(
      id: 'lion-scout',
      name: 'Lion Scout',
      lastMessage: 'Show. Manda seu material e seguimos.',
      timeLabel: '11:18',
      avatarLabel: 'LS',
      messages: [
        ChatMessage(
          text: 'Vi seu perfil no marketplace.',
          isMe: false,
          timestamp: DateTime(2026, 3, 28, 11, 12),
        ),
        ChatMessage(
          text: 'Perfeito, posso enviar meus melhores lances.',
          isMe: true,
          timestamp: DateTime(2026, 3, 28, 11, 15),
        ),
        ChatMessage(
          text: 'Show. Manda seu material e seguimos.',
          isMe: false,
          timestamp: DateTime(2026, 3, 28, 11, 18),
        ),
      ],
    ),
    ChatConversation(
      id: 'base-verde',
      name: 'Base Verde FC',
      lastMessage: 'Treino aberto confirmado para amanhã.',
      timeLabel: '09:05',
      avatarLabel: 'BV',
      messages: [
        ChatMessage(
          text: 'Recebemos seu cadastro por aqui.',
          isMe: false,
          timestamp: DateTime(2026, 3, 28, 8, 55),
        ),
        ChatMessage(
          text: 'Excelente, obrigado pelo retorno.',
          isMe: true,
          timestamp: DateTime(2026, 3, 28, 9, 0),
        ),
        ChatMessage(
          text: 'Treino aberto confirmado para amanhã.',
          isMe: false,
          timestamp: DateTime(2026, 3, 28, 9, 5),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ChatConversation>>(
      valueListenable: ChatStore.conversations,
      builder: (context, conversations, _) {
        return ColoredBox(
          color: _screenBackground,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            itemCount: conversations.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final conversation = conversations[index];

              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () =>
                    context.push('/chat/conversation/${conversation.id}'),
                child: Ink(
                  decoration: BoxDecoration(
                    color: _cardColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            conversation.avatarLabel,
                            style: const TextStyle(
                              color: _darkGreen,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              conversation.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              conversation.lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        conversation.timeLabel,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
