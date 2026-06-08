import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ChatMensagemService {
  late final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'default',
  );

  final String _collectionName = 'chats';
  // final String _subcollectionName = 'mensagens';

  Stream<List<QueryDocumentSnapshot>> listarMeusChats(String uid) {
    return _firestore
        .collection(_collectionName)
        .where('participantes', arrayContains: uid)
        .orderBy('atualizado_em', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
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
