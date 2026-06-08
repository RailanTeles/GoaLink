import 'package:flutter/material.dart';
import 'package:goalink/models/chat_model.dart';
import 'package:goalink/repositories/chat_mensagem_repository.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatMensagemRepository _chatRepository;

  ChatViewModel(this._chatRepository);

  String? _erro;
  Stream<List<ChatModel>>? _chatsStream;

  String? get erro => _erro;
  Stream<List<ChatModel>>? get chatsStream => _chatsStream;

  Future<void> obterMeusChats(String uid) async {
    notifyListeners();
    try {
      _chatsStream = _chatRepository.listarMeusChats(uid);
    } catch (e) {
      _erro = e.toString().replaceAll('Exception: ', '');
      debugPrint('Erro ao carregar conversas: $_erro');
    } finally {
      notifyListeners();
    }
  }
}
