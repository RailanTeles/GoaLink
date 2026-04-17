import 'package:flutter/foundation.dart';
import 'package:goalink/repositories/usuario_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final UsuarioRepository _repository;

  bool isLoading = false;

  LoginViewModel(this._repository);

  Future<String?> fazerLogin(String email, String senha) async {
    if (email.isEmpty || senha.isEmpty) {
      throw Exception('Preencha todos os campos.');
    }
    isLoading = true;
    notifyListeners();
    try {
      await _repository.fazerLogin(email, senha);
      return null;
    } catch (e) {
      return e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
