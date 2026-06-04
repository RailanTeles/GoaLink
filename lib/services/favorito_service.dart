import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FavoritoService {
  late final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'default',
  );

  final String _collectionName = 'favoritos';

  Future<List<DocumentSnapshot>> obterFavoritos(String uidInteressado) async {
    try {
      final resultado = await _firestore
          .collection(_collectionName)
          .where('interessado_id', isEqualTo: uidInteressado)
          .orderBy('criado_em', descending: true)
          .get();

      return resultado.docs;
    } catch (e) {
      throw Exception('Erro ao obter favoritos: $e');
    }
  }

  Future<void> deletarFavorito(String docId) async {
    try {
      await _firestore.collection(_collectionName).doc(docId).delete();
    } catch (e) {
      throw Exception("Erro ao remover do favorito: $e");
    }
  }

  Future<void> deletarFavoritosUsuario(String uid) async {
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
      throw Exception('Erro ao deletar favoritos do usuário: $e');
    }
  }
}
