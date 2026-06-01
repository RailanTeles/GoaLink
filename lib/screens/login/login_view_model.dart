import 'package:flutter/foundation.dart';
import 'package:goalink/repositories/usuario_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final UsuarioRepository _repository;

  bool _isLoading = false;
  String? _erroSnackBar;

  bool get isLoading => _isLoading;
  String? get erroSnackBar => _erroSnackBar;

  LoginViewModel(this._repository);

  Future<String?> fazerLogin(String email, String senha) async {
    if (email.isEmpty || senha.isEmpty) {
      return 'Preencha todos os campos.';
    }
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.fazerLogin(email, senha);
      return null;
    } catch (e) {
      return e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      try {
        notifyListeners(); // pode falhar se widget já foi destruído
      } catch (_) {}
    }
  }
}
