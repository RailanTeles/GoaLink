import 'package:flutter/foundation.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/repositories/usuario_repository.dart';
import 'package:goalink/services/storage_service.dart';
import 'package:image_picker/image_picker.dart';

class RegisterClubeViewModel extends ChangeNotifier {
  final UsuarioRepository _repository;
  final StorageService _storageService;

  RegisterClubeViewModel(this._repository, this._storageService);

  bool isLoading = false;
  String? erro;
  XFile? fotoPerfil;

  void setFotoPerfil(XFile? foto) {
    fotoPerfil = foto;
    notifyListeners();
  }

  bool _isValidEmail(String email) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());

  String? validar({
    required String nomeClube,
    required String email,
    required String senha,
    required String confirmarSenha,
    required String cidade,
    required String descricao,
    required String jogadoresProcurados,
  }) {
    if (nomeClube.trim().isEmpty) return 'Informe o nome do clube.';
    if (!_isValidEmail(email)) return 'E-mail inválido.';
    if (senha.length < 6) return 'A senha deve ter ao menos 6 caracteres.';
    if (senha != confirmarSenha) return 'As senhas não coincidem.';
    if (cidade.trim().isEmpty) return 'Informe a cidade do clube.';
    if (descricao.trim().isEmpty) return 'Escreva uma descrição sobre o clube.';
    if (jogadoresProcurados.trim().isEmpty) return 'Informe os jogadores que procura.';
    return null;
  }

  Future<String?> cadastrar({
    required String nomeClube,
    required String email,
    required String senha,
    required String confirmarSenha,
    required String cidade,
    required String descricao,
    required String jogadoresProcurados,
  }) async {
    erro = validar(
      nomeClube: nomeClube,
      email: email,
      senha: senha,
      confirmarSenha: confirmarSenha,
      cidade: cidade,
      descricao: descricao,
      jogadoresProcurados: jogadoresProcurados,
    );
    if (erro != null) {
      notifyListeners();
      return erro;
    }

    isLoading = true;
    notifyListeners();

    try {
      final usuario = UsuarioModel(
        id: '',
        tipo: 'clube',
        email: email.trim(),
        nome: nomeClube.trim(),
        criadoEm: DateTime.now(),
        cidade: cidade.trim(),
        descricao: descricao.trim(),
        jogadoresProcurados: jogadoresProcurados.trim(),
      );

      await _repository.cadastrarUsuario(usuario, senha, fotoPerfil?.path, _storageService);
      erro = null;
      return null;
    } catch (e) {
      erro = e.toString().replaceAll('Exception: ', '');
      return erro;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
