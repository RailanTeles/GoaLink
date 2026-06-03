import 'package:flutter/material.dart';
import 'package:goalink/repositories/usuario_repository.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final UsuarioRepository _repository;

  bool _isLoading = false;
  String? _erroSnackBar;
  String? _sucessoSnackBar;

  bool get isLoading => _isLoading;
  String? get erroSnackBar => _erroSnackBar;
  String? get sucessoSnackBar => _sucessoSnackBar;

  ForgotPasswordViewModel(this._repository);

  Future<void> recuperarSenha(String email) async {
    _erroSnackBar = null;
    _sucessoSnackBar = null;
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.recuperarSenha(email);
      _sucessoSnackBar =
          'E-mail enviado com sucesso! Verifique sua caixa de entrada ou spam.';
    } catch (e) {
      _erroSnackBar = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
