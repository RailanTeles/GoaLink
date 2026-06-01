import 'package:flutter/foundation.dart';
import 'package:goalink/repositories/usuario_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final UsuarioRepository _repository;

  bool _isLoading = false;
  String? _erroSnackBar;

  bool get isLoading => _isLoading;
  String? get erroSnackBar => _erroSnackBar;

  LoginViewModel(this._repository);

  Future<void> fazerLogin(String email, String senha) async {
    _erroSnackBar = null;
    _isLoading = true;
    notifyListeners();

    if (email.isEmpty || senha.isEmpty) {
      _erroSnackBar = 'Preencha todos os campos.';
      _isLoading = false;
      notifyListeners();
      return;
    }
    try {
      await _repository.fazerLogin(email, senha);
    } catch (e) {
      _erroSnackBar = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
