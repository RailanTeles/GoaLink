import 'package:goalink/models/chat_model.dart';
import 'package:goalink/services/chat_mensagem_service.dart';

class ChatMensagemRepository {
  final ChatMensagemService _service;

  ChatMensagemRepository(this._service);

  Stream<List<ChatModel>> listarMeusChats(String uid) {
    return _service.listarMeusChats(uid).map((docs) {
      return docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ChatModel.fromJson(data);
      }).toList();
    });
  }
}
