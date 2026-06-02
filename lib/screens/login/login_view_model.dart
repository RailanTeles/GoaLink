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
    _erroSnackBar = null;

    if (email.isEmpty || senha.isEmpty) {
      _isLoading = false;
      notifyListeners();
      return null;
    }
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.fazerLogin(email, senha);
      return null;
    } catch (e) {
      _erroSnackBar = e.toString().replaceAll('Exception: ', '');
      return _erroSnackBar;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
