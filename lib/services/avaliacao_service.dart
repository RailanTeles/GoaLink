import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AvaliacaoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'default',
  );

  final String _collectionName = 'avaliacoes';

  Future<List<QueryDocumentSnapshot>> obterAvaliacoesUsuario(String uid) async {
    try {
      var snapshot = await _firestore
          .collection(_collectionName)
          .where('avaliado_id', isEqualTo: uid)
          .orderBy('criado_em', descending: true)
          .get();
      return snapshot.docs;
    } catch (e) {
      throw Exception('Erro ao obter avaliações do usuário: $e');
    }
  }
}
