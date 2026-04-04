import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/models/chat_conversation.dart';
import 'package:goalink/models/chat_message.dart';
import 'package:goalink/services/chat_mock_service.dart';

class ChatStore {
  ChatStore._();

  static const String currentUserId = 'jogador_01';
  static final ChatMockService _chatMockService = ChatMockService();
  static final ValueNotifier<List<ChatConversation>> conversations =
      ValueNotifier<List<ChatConversation>>([]);
  static bool _initialized = false;

  static Future<void> ensureInitialized() async {
    if (_initialized) {
      return;
    }

    final loadedConversations = await _chatMockService.getConversations(
      currentUserId,
    );
    conversations.value = loadedConversations;
    _initialized = true;
  }

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
  static const Color _darkGreen = Color(0xFF195E3B);
  static const Color _screenBackground = Color(0xFFF4F4F2);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: ChatStore.ensureInitialized(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const ColoredBox(
            color: _screenBackground,
            child: Center(
              child: CircularProgressIndicator(color: _darkGreen),
            ),
          );
        }

        if (snapshot.hasError) {
          return ColoredBox(
            color: _screenBackground,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Nao foi possivel carregar os chats.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

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
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
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
      },
    );
  }
}
