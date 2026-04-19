import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goalink/models/usuario_model.dart';

class UsuarioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'default',
  );

  Future<void> cadastrarUsuarioNoBanco(UsuarioModel usuario) async {
    try {
      await _firestore
          .collection('usuarios')
          .doc(usuario.id)
          .set(usuario.toJson());
    } catch (e) {
      throw Exception('Erro ao criar usuário: $e');
    }
  }
}
