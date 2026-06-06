import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DicaTreinoExercicioService {
  late final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'default',
  );

  // Collection Principal
  final String _collectionName = 'dica_treino';
  // Subcollection
  final String _subcollectionName = 'exercicio';

  Future<List<DocumentSnapshot>> obterDicasTreino() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('criado_em', descending: true)
          .limit(10)
          .get();
      return querySnapshot.docs;
    } catch (e) {
      throw Exception('Erro ao obter dicas de treino: $e');
    }
  }

  Future<List<DocumentSnapshot>> obterExercicio(String idDica) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .doc(idDica)
          .collection(_subcollectionName)
          .get();
      return querySnapshot.docs;
    } catch (e) {
      throw Exception('Erro ao obter exercícios: $e');
    }
  }
}
