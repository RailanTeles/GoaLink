import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/repositories/usuario_repository.dart';

class SettingsViewModel extends ChangeNotifier {
  final UsuarioRepository _usuarioRepository;
  UsuarioModel? _usuario;
  bool _isLoading = false;
  bool _isSalving = false;
  bool _isSalvingPassword = false;
  bool _isSalvingPreferences = false;
  String? _erro;
  String? _erroSnackBar;
  String? _sucessoSnackBar;

  UsuarioModel? get usuario => _usuario;
  bool get isLoading => _isLoading;
  bool get isSalving => _isSalving;
  bool get isSalvingPassword => _isSalvingPassword;
  bool get isSalvingPreferences => _isSalvingPreferences;
  String? get erro => _erro;
  String? get erroSnackBar => _erroSnackBar;
  String? get sucessoSnackBar => _sucessoSnackBar;

  SettingsViewModel(this._usuarioRepository);

  Future<void> obterUsuario() async {
    _erro = null;
    _isLoading = true;
    notifyListeners();
    try {
      _usuario = await _usuarioRepository.obterUsuarioLogado();
    } catch (e) {
      _erro = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> editarUsuario(
    String nome,
    String? altura,
    String? peso,
    String? cidade,
    String? dataNascimento,
    String? posicao,
    String? pePreferido,
    String? descricao,
    String? caminhoFoto,
    Map<String, dynamic>? redesSociais,
    String? clubeRepresentante,
    String? jogadoresProcurados,
    bool removerFoto,
  ) async {
    _erroSnackBar = null;
    _sucessoSnackBar = null;
    _isSalving = true;
    notifyListeners();

    try {
      double? pesoFormatado = (peso != null && peso.isNotEmpty)
          ? double.tryParse(peso.replaceAll(',', '.'))
          : _usuario?.peso;

      double? alturaFormatada = (altura != null && altura.isNotEmpty)
          ? double.tryParse(altura.replaceAll(',', '.'))
          : _usuario?.altura;

      DateTime? dataNascFormatada = _usuario?.dataNascimento;
      if (dataNascimento != null && dataNascimento.isNotEmpty) {
        final partes = dataNascimento.split('/');
        if (partes.length == 3) {
          dataNascFormatada = DateTime(
            int.parse(partes[2]),
            int.parse(partes[1]),
            int.parse(partes[0]),
          );
        }
      }

      UsuarioModel usuarioEditado = _usuario!.copyWith(
        nome: nome,
        altura: alturaFormatada,
        peso: pesoFormatado,
        cidade: cidade,
        dataNascimento: dataNascFormatada,
        posicao: posicao,
        pernaPreferida: pePreferido,
        descricao: descricao,
        redesSociais: redesSociais,
        clubeRepresentante: clubeRepresentante,
        jogadoresProcurados: jogadoresProcurados,
      );

      await _usuarioRepository.atualizarUsuario(
        usuarioEditado,
        caminhoFoto,
        removerFoto,
      );

      _usuario = usuarioEditado;
      _sucessoSnackBar = "Perfil atualizado com sucesso!";
      return true;
    } catch (e) {
      _erroSnackBar =
          "Erro ao editar Perfil: ${e.toString().replaceAll('Exception: ', '')}";
      return false;
    } finally {
      _isSalving = false;
      notifyListeners();
    }
  }

  Future<bool> alterarSenha(
    String senhaAntiga,
    String senhaNova,
    String confirmarSenha,
  ) async {
    _erroSnackBar = null;
    _sucessoSnackBar = null;

    if (senhaNova != confirmarSenha) {
      _erroSnackBar = "A nova senha e a confirmação de senha não coincidem.";
      notifyListeners();
      return false;
    }

    _isSalvingPassword = true;
    notifyListeners();
    try {
      await _usuarioRepository.alterarSenha(senhaAntiga, senhaNova);
      _sucessoSnackBar = "Senha alterada com sucesso!";
      return true;
    } catch (e) {
      _erroSnackBar =
          "Erro ao Alterar Senha: ${e.toString().replaceAll('Exception: ', '')}";
      return false;
    } finally {
      _isSalvingPassword = false;
      notifyListeners();
    }
  }

  Future<bool> deletarConta(String senha) async {
    _erroSnackBar = null;
    _isSalving = true;
    notifyListeners();

    try {
      final String uid = _usuario!.id;
      final String? fotoUrl = _usuario!.fotoUrl;

      await _usuarioRepository.deletarConta(senha, uid, fotoUrl);
      _sucessoSnackBar = "Conta deletada com sucesso!";
      return true;
    } catch (e) {
      _erroSnackBar =
          "Erro ao Deletar Conta: ${e.toString().replaceAll('Exception: ', '')}";
      return false;
    } finally {
      _isSalving = false;
      notifyListeners();
    }
  }

  Future<bool> sair() async {
    _erroSnackBar = null;
    _sucessoSnackBar = null;
    _isSalving = true;
    notifyListeners();

    try {
      await _usuarioRepository.fazerLogout();
      _sucessoSnackBar = "Logout realizado com sucesso!";
      return true;
    } catch (e) {
      _erroSnackBar =
          "Erro ao Fazer Logout: ${e.toString().replaceAll('Exception: ', '')}";
      return false;
    } finally {
      _isSalving = false;
      notifyListeners();
    }
  }

  Future<bool> atualizarPreferenciasNotificacao(
    bool interesseClubes,
    bool mensagens,
    bool atualizacoes,
  ) async {
    _erroSnackBar = null;
    _sucessoSnackBar = null;
    _isSalvingPreferences = true;
    notifyListeners();

    try {
      Map<String, dynamic> preferencias = {
        'interesseClubes': interesseClubes,
        'mensagens': mensagens,
        'atualizacoes': atualizacoes,
      };

      UsuarioModel usuarioEditado = _usuario!.copyWith(
        preferenciasNotificacao: preferencias,
      );

      await _usuarioRepository.atualizarUsuario(usuarioEditado, null, false);

      _usuario = usuarioEditado;
      _sucessoSnackBar = "Preferências de notificação salvas com sucesso!";
      return true;
    } catch (e) {
      _erroSnackBar =
          "Erro ao salvar notificações: ${e.toString().replaceAll('Exception: ', '')}";
      return false;
    } finally {
      _isSalvingPreferences = false;
      notifyListeners();
    }
  }
}
