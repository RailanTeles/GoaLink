import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goalink/models/usuario_model.dart';

class UsuarioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
