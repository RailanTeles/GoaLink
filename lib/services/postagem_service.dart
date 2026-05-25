import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goalink/models/postagem_model.dart';

class PostagemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'default',
  );

  final String _collectionName = 'postagens';

  Future<List<QueryDocumentSnapshot>> obterPostagensFeed({
    int quantidade = 5,
    DocumentSnapshot? ultimoDoc,
  }) async {
    try {
      var query = _firestore
          .collection(_collectionName)
          .orderBy('criado_em', descending: true)
          .limit(quantidade);

      if (ultimoDoc != null) {
        query = query.startAfterDocument(ultimoDoc);
      }

      final snapshot = await query.get();
      return snapshot.docs;
    } catch (e) {
      throw Exception('Erro ao obter postagens feed: $e');
    }
  }

  Future<String> criarRefPostagem() async {
    try {
      final docRef = _firestore.collection(_collectionName).doc();
      return docRef.id;
    } catch (e) {
      throw Exception('Erro ao criar referência de postagem: $e');
    }
  }

  Future<void> criarPostagem(PostagemModel postagem) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(postagem.idPostagem)
          .set(postagem.toJson());
    } catch (e) {
      throw Exception('Erro ao criar postagem: $e');
    }
  }

  Future<void> deletarPostagem(String idPostagem) async {
    try {
      await _firestore.collection(_collectionName).doc(idPostagem).delete();
    } catch (e) {
      throw Exception('Erro ao deletar postagem: $e');
    }
  }

  Future<List<QueryDocumentSnapshot>> obterPostagensUsuario(String uid) async {
    try {
      var snapshot = await _firestore
          .collection(_collectionName)
          .where('jogador_id', isEqualTo: uid)
          .orderBy('criado_em', descending: true)
          .get();
      return snapshot.docs;
    } catch (e) {
      throw Exception('Erro ao obter postagens do usuário: $e');
    }
  }
}
