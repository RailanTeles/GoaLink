import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goalink/models/chat_model.dart';
import 'package:goalink/models/messagem_model.dart';

class ChatMensagemService {
  late final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'default',
  );

  final String _collectionName = 'chats';
  final String _subcollectionName = 'mensagens';

  Stream<List<QueryDocumentSnapshot>> listarMeusChats(String uid) {
    return _firestore
        .collection(_collectionName)
        .where('participantes', arrayContains: uid)
        .orderBy('atualizado_em', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Stream<List<QueryDocumentSnapshot>> ouvirMensagens(String idChat) {
    return _firestore
        .collection(_collectionName)
        .doc(idChat)
        .collection(_subcollectionName)
        .orderBy('criado_em', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Stream<DocumentSnapshot> ouvirDetalhesChat(String idChat) {
    return _firestore.collection(_collectionName).doc(idChat).snapshots();
  }

  Future<void> enviarMensagem(ChatModel chat, MensagemModel mensagem) async {
    try {
      WriteBatch batch = _firestore.batch();

      final chatRef = _firestore.collection(_collectionName).doc(chat.idChat);
      final mensagemRef = chatRef.collection(_subcollectionName).doc();

      batch.set(mensagemRef, mensagem.toJson());
      batch.set(chatRef, chat.toJson(), SetOptions(merge: true));

      await batch.commit();
    } catch (e) {
      throw Exception('Erro ao enviar mensagem: $e');
    }
  }

  Future<void> marcarMensagensComoLidas(
    String idChat,
    String meuUid,
    String outroUid,
  ) async {
    try {
      WriteBatch batch = _firestore.batch();
      final chatRef = _firestore.collection(_collectionName).doc(idChat);

      batch.update(chatRef, {'mensagens_nao_lidas.$meuUid': 0});

      final query = await chatRef
          .collection(_subcollectionName)
          .where('remetente_id', isEqualTo: outroUid)
          .where('lida', isEqualTo: false)
          .get();

      for (var doc in query.docs) {
        batch.update(doc.reference, {'lida': true});
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Erro ao marcar como lida: $e');
    }
  }

  Future<void> atualizarEstadoDigitando(
    String idChat,
    String meuUid,
    bool estaDigitando,
  ) async {
    try {
      await _firestore.collection(_collectionName).doc(idChat).update({
        'digitando.$meuUid': estaDigitando,
      });
    } catch (e) {
      throw Exception('Erro ao atualizar digitação: $e');
    }
  }

  Future<void> softDeletarMensagensChat(String uid) async {
    try {
      final query = await _firestore
          .collection(_collectionName)
          .where('participantes', arrayContains: uid)
          .get();

      if (query.docs.isEmpty) return;

      WriteBatch batch = _firestore.batch();

      for (var doc in query.docs) {
        batch.update(doc.reference, {
          'usuarios_dados.$uid': {
            'nome': 'Usuário Excluído',
            'foto_perfil': null,
            'tipo': 'excluido',
          },
        });
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Erro ao anonimizar chats do usuário: $e');
    }
  }
}
