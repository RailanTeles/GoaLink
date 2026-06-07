import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goalink/models/avaliacao_model.dart';

class AvaliacaoService {
  late final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'default',
  );

  final String _collectionName = 'avaliacoes';

  Future<List<QueryDocumentSnapshot>> obterAvaliacoesUsuario(String uid) async {
    try {
      var snapshot = await _firestore
          .collection(_collectionName)
          .where('jogador_id', isEqualTo: uid)
          .orderBy('criado_em', descending: true)
          .get();
      return snapshot.docs;
    } catch (e) {
      throw Exception('Erro ao obter avaliações do usuário: $e');
    }
  }

  Future<void> adicionarAvaliacao(AvaliacaoModel avaliacao) async {
    try {
      await _firestore.collection(_collectionName).add(avaliacao.toJson());
    } catch (e) {
      throw Exception('Erro ao adicionar avaliação: $e');
    }
  }

  Future<void> deletarAvaliacoesUsuario(String uid) async {
    try {
      final resultados = await Future.wait([
        _firestore
            .collection(_collectionName)
            .where('jogador_id', isEqualTo: uid)
            .get(),
        _firestore
            .collection(_collectionName)
            .where('autor_id', isEqualTo: uid)
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
      throw Exception('Erro ao deletar avaliações do usuário: $e');
    }
  }
}
