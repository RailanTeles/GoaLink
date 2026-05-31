import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  late final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<void> alterarSenha(String senhaAntiga, String senhaNova) async {
    try {
      await _auth.currentUser!.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: _auth.currentUser!.email!,
          password: senhaAntiga,
        ),
      );
      await _auth.currentUser!.updatePassword(senhaNova);
    } on FirebaseAuthException catch (e) {
      throw Exception(_traduzirErroFirebase(e.code));
    }
  }

  Future<void> deletarConta() async {
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      throw Exception(_traduzirErroFirebase(e.code));
    }
  }

  Future<void> verificarSenha(String senha) async {
    try {
      await _auth.currentUser!.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: _auth.currentUser!.email!,
          password: senha,
        ),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_traduzirErroFirebase(e.code));
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
