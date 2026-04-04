import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:goalink/models/chat_conversation.dart';
import 'package:goalink/models/chat_message.dart';

class ChatMockService {
  Future<List<ChatConversation>> getConversations(String currentUserId) async {
    final chatsResponse = await rootBundle.loadString(
      'assets/mocks/chats_e_mensagens.json',
    );
    final List<dynamic> chatsData = json.decode(chatsResponse);

    return chatsData.map((item) {
      final jsonItem = item as Map<String, dynamic>;
      final participants = List<String>.from(jsonItem['participantes'] ?? []);
      final otherParticipantId = participants.firstWhere(
        (participantId) => participantId != currentUserId,
        orElse: () => currentUserId,
      );
      final name =
          (jsonItem['nome_contato'] as String?) ??
          (jsonItem['contact_name'] as String?) ??
          otherParticipantId;
      final messagesJson = jsonItem['mensagens'] as List? ?? [];
      final messages = messagesJson.map((message) {
        final jsonMessage = message as Map<String, dynamic>;
        return ChatMessage(
          text: jsonMessage['texto'] ?? '',
          isMe: jsonMessage['remetente_id'] == currentUserId,
          timestamp: DateTime.parse(jsonMessage['criado_em']),
        );
      }).toList();

      return ChatConversation(
        id: jsonItem['id_chat'] ?? '',
        name: name,
        lastMessage: jsonItem['ultima_mensagem'] ?? '',
        timeLabel: _formatTime(DateTime.parse(jsonItem['atualizado_em'])),
        avatarLabel:
            (jsonItem['avatar_label'] as String?) ?? _buildAvatarLabel(name),
        messages: messages,
      );
    }).toList();
  }

  String _buildAvatarLabel(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty);
    final initials = parts.take(2).map((part) => part[0].toUpperCase()).join();
    return initials.isEmpty ? 'CT' : initials;
  }

  String _formatTime(DateTime timestamp) {
    final local = timestamp.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
