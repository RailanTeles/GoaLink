import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goalink/models/postagem_model.dart';

class PostagemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'default',
  );

  final String _collectionName = 'postagens';

  Future<List<PostagemModel>> obterPostagensFeed({int quantidade = 5}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('criado_em', descending: true)
          .limit(quantidade)
          .get();
      if (querySnapshot.docs.isEmpty) {
        return [];
      }
      return querySnapshot.docs
          .map((doc) => PostagemModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Erro ao obter postagens feed: $e');
    }
  }
}
