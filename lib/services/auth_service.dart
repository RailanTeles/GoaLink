import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:goalink/models/usuario_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> criarInstanciaUsuario(String email, String senha) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_traduzirErroFirebase(e.code));
    }
  }

  Future<User?> login(String email, String senha) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_traduzirErroFirebase(e.code));
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<User> obterUsuarioLogado() async {
    return _auth.currentUser!;
  }

  Future<UsuarioModel?> obterUsuarioUid(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('usuarios')
          .doc(uid)
          .get();
      if (snapshot.exists && snapshot.data() != null) {
        return UsuarioModel.fromJson(snapshot.data()!);
      }

      return null;
    } catch (e) {
      throw Exception('Erro ao buscar usuário: $e');
    }
  }

  String _traduzirErroFirebase(String codigo) {
    switch (codigo) {
      case 'weak-password':
        return 'A senha deve ter pelo menos 6 caracteres.';
      case 'email-already-in-use':
        return 'Já existe uma conta com este e-mail.';
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return 'E-mail ou senha incorretos.';
      case 'invalid-email':
        return 'E-mail inválido.';
      default:
        return 'Ocorreu um erro inesperado. Tente novamente.';
    }
  }
}
