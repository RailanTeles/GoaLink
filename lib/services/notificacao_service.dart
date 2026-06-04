import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class NotificacaoService {
  late final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'default',
  );

  final String _collectionName = 'notificacoes';

  Future<void> deletarNotificacoesUsuario(String uid) async {
    try {
      final resultados = await Future.wait([
        _firestore
            .collection(_collectionName)
            .where('usuario_id', isEqualTo: uid)
            .get(),
        _firestore
            .collection(_collectionName)
            .where('remetente_id', isEqualTo: uid)
            .get(),
      ]);

      final queryRecebidas = resultados[0];
      final queryFeitas = resultados[1];

      if (queryRecebidas.docs.isEmpty && queryFeitas.docs.isEmpty) return;

      WriteBatch batch = _firestore.batch();

      for (var doc in queryRecebidas.docs) {
        batch.delete(doc.reference);
      }

      for (var doc in queryFeitas.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Erro ao deletar notificações do usuário: $e');
    }
  }

  Future<List<QueryDocumentSnapshot>> obterNotificacoesUsuario(
    String uid,
  ) async {
    try {
      var snapshot = await _firestore
          .collection(_collectionName)
          .where('usuario_id', isEqualTo: uid)
          .orderBy('criado_em', descending: true)
          .limit(60)
          .get();

      return snapshot.docs;
    } catch (e) {
      throw Exception('Erro ao obter notificação do usuário: $e');
    }
  }

  Future<void> marcarNotificacoesComoLidas(List<String> ids) async {
    try {
      WriteBatch batch = _firestore.batch();

      for (var id in ids) {
        batch.update(_firestore.collection(_collectionName).doc(id), {
          'lida': true,
        });
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Erro ao marcar notificações como lidas: $e');
    }
  }
}
