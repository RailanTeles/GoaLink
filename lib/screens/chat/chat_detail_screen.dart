import 'package:flutter/material.dart';
import 'package:goalink/models/chat_conversation.dart';
import 'package:goalink/models/chat_message.dart';
import 'package:goalink/screens/chat/chat_screen.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key, required this.chatId});

  final String chatId;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  static const Color _darkGreen = Color(0xFF195E3B);
  static const Color _lightGray = Color(0xFFE0E0E0);
  static const Color _screenBackground = Color(0xFFF7F7F7);

  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      return;
    }

    ChatStore.addMessage(
      widget.chatId,
      ChatMessage(text: text, isMe: true, timestamp: DateTime.now()),
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: ChatStore.ensureInitialized(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: _screenBackground,
            body: Center(
              child: CircularProgressIndicator(color: _darkGreen),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: _screenBackground,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Nao foi possivel carregar a conversa.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final conversation = ChatStore.getConversation(widget.chatId);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: _screenBackground,
          appBar: AppBar(
            backgroundColor: _darkGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            titleSpacing: 0,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Text(
                    conversation.avatarLabel,
                    style: const TextStyle(
                      color: _darkGreen,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    conversation.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            top: false,
            child: ValueListenableBuilder<List<ChatConversation>>(
              valueListenable: ChatStore.conversations,
              builder: (context, conversations, _) {
                final currentConversation = conversations.firstWhere(
                  (chat) => chat.id == widget.chatId,
                );
                final messages = currentConversation.messages;

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[messages.length - 1 - index];
                          return Align(
                            alignment: message.isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.sizeOf(context).width * 0.72,
                              ),
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: message.isMe ? _darkGreen : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(22),
                                  topRight: const Radius.circular(22),
                                  bottomLeft: Radius.circular(
                                    message.isMe ? 22 : 8,
                                  ),
                                  bottomRight: Radius.circular(
                                    message.isMe ? 8 : 22,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                message.text,
                                style: TextStyle(
                                  color: message.isMe
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    AnimatedPadding(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.viewInsetsOf(context).bottom,
                      ),
                      child: Container(
                        color: _lightGray,
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                textInputAction: TextInputAction.send,
                                onSubmitted: (_) => _sendMessage(),
                                decoration: InputDecoration(
                                  hintText: 'Digite sua mensagem...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 13,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: const BorderSide(
                                      color: _darkGreen,
                                      width: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: _sendMessage,
                                child: const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Icon(
                                    Icons.send_outlined,
                                    color: _darkGreen,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
