import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goalink/models/favorito_model.dart';

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

  Future<void> adicionarFavorito(FavoritoModel favorito) async {
    try {
      await _firestore.collection(_collectionName).add(favorito.toJson());
    } catch (e) {
      throw Exception("Erro ao adicionar aos favoritos: $e");
    }
  }

  Future<void> removerFavorito(String meuUsuarioId, String uid) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('interessado_id', isEqualTo: meuUsuarioId)
          .where('id_favorito', isEqualTo: uid)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception("Erro ao remover do favorito: $e");
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

  Future<bool> verificarFavorito(
    String uidInteressado,
    String uidFavorito,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('interessado_id', isEqualTo: uidInteressado)
          .where('id_favorito', isEqualTo: uidFavorito)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Erro ao verificar favorito: $e');
    }
  }
}
