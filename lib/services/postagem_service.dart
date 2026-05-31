import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goalink/models/postagem_model.dart';

class PostagemService {
  late final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
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

  Future<void> sincronizarDadosDoAutor(
    String uid,
    String novoNome,
    String? novaFotoUrl,
  ) async {
    try {
      final query = await _firestore
          .collection('postagens')
          .where('jogador_id', isEqualTo: uid)
          .get();

      if (query.docs.isEmpty) return;

      WriteBatch batch = _firestore.batch();

      for (var doc in query.docs) {
        Map<String, dynamic> dadosAtualizados = {
          'jogador_nome': novoNome,
          'jogador_foto_url': novaFotoUrl,
        };

        batch.update(doc.reference, dadosAtualizados);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Erro ao sincronizar autor nas postagens: $e');
    }
  }

  Future<List<String>> deletarPostagensUsuario(String uid) async {
    try {
      final query = await _firestore
          .collection(_collectionName)
          .where('jogador_id', isEqualTo: uid)
          .get();

      if (query.docs.isEmpty) return [];

      final List<String> urlsParaDeletar = query.docs
          .map((doc) => doc.data()['midia_url'] as String?)
          .where((url) => url != null && url.isNotEmpty)
          .cast<String>()
          .toList();

      WriteBatch batch = _firestore.batch();

      for (var doc in query.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      return urlsParaDeletar;
    } catch (e) {
      throw Exception('Erro ao deletar postagens do usuário: $e');
    }
  }
}
