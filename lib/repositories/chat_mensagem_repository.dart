import 'package:goalink/models/chat_model.dart';
import 'package:goalink/models/messagem_model.dart';
import 'package:goalink/services/chat_mensagem_service.dart';

class ChatMensagemRepository {
  final ChatMensagemService _service;

  ChatMensagemRepository(this._service);

  Stream<List<ChatModel>> listarMeusChats(String uid) {
    return _service.listarMeusChats(uid).map((docs) {
      return docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id_chat'] = doc.id;
        return ChatModel.fromJson(data);
      }).toList();
    });
  }

  Stream<List<MensagemModel>> ouvirMensagens(String idChat) {
    return _service.ouvirMensagens(idChat).map((docs) {
      return docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id_mensagem'] = doc.id;
        return MensagemModel.fromJson(data);
      }).toList();
    });
  }

  Stream<ChatModel?> ouvirDetalhesChat(String idChat) {
    return _service.ouvirDetalhesChat(idChat).map((doc) {
      if (!doc.exists || doc.data() == null) return null;

      final data = doc.data() as Map<String, dynamic>;
      data['id_chat'] = doc.id;
      return ChatModel.fromJson(data);
    });
  }

  Future<void> enviarMensagem(
    ChatModel chatAtual,
    String meuUid,
    String outroUid,
    String textoMensagem,
  ) async {
    final novaMensagem = MensagemModel(
      idMensagem: '',
      remetenteId: meuUid,
      texto: textoMensagem,
      criadoEm: DateTime.now(),
      lida: false,
    );

    final mapaNaoLidas = Map<String, int>.from(chatAtual.mensagensNaoLidas);
    mapaNaoLidas[outroUid] = (mapaNaoLidas[outroUid] ?? 0) + 1;

    final chatAtualizado = chatAtual.copyWith(
      ultimaMensagem: textoMensagem,
      atualizadoEm: DateTime.now(),
      mensagensNaoLidas: mapaNaoLidas,
    );

    await _service.enviarMensagem(chatAtualizado, novaMensagem);
  }

  Future<void> marcarMensagensComoLidas(
    String idChat,
    String meuUid,
    String outroUid,
  ) async {
    return await _service.marcarMensagensComoLidas(idChat, meuUid, outroUid);
  }

  Future<void> atualizarEstadoDigitando(
    String idChat,
    String meuUid,
    bool estaDigitando,
  ) async {
    return await _service.atualizarEstadoDigitando(
      idChat,
      meuUid,
      estaDigitando,
    );
  }
}
