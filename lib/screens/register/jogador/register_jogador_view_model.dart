import 'package:flutter/foundation.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/repositories/usuario_repository.dart';
import 'package:goalink/services/storage_service.dart';
import 'package:image_picker/image_picker.dart';

class RegisterJogadorViewModel extends ChangeNotifier {
  final UsuarioRepository _repository;
  final StorageService _storageService;

  RegisterJogadorViewModel(this._repository, this._storageService);

  bool isLoading = false;
  String? erro;
  XFile? fotoPerfil;

  static const List<String> posicoes = [
    'Goleiro',
    'Zagueiro',
    'Lateral direito',
    'Lateral esquerdo',
    'Volante',
    'Meio-campo',
    'Meia ofensivo',
    'Ponta direita',
    'Ponta esquerda',
    'Atacante',
    'Centroavante',
  ];

  static const List<String> pernasPreferidas = [
    'Direita',
    'Esquerda',
    'Ambidestro',
  ];

  bool isValidEmail(String email) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());

  bool isValidBirthDate(String value) {
    final match = RegExp(r'^(\d{2})\/(\d{2})\/(\d{4})$').firstMatch(value);
    if (match == null) return false;
    final day = int.tryParse(match.group(1)!);
    final month = int.tryParse(match.group(2)!);
    final year = int.tryParse(match.group(3)!);
    if (day == null || month == null || year == null) return false;
    if (month < 1 || month > 12 || day < 1) return false;
    final date = DateTime.tryParse(
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}',
    );
    return date != null &&
        date.day == day &&
        date.month == month &&
        date.year == year &&
        !date.isAfter(DateTime.now());
  }

  bool isValidAltura(String value) {
    final n = double.tryParse(value.replaceAll(',', '.'));
    return n != null && n >= 0.5 && n <= 3.0;
  }

  bool isValidPeso(String value) {
    final n = double.tryParse(value.replaceAll(',', '.'));
    return n != null && n >= 20 && n <= 300;
  }

  String? validar({
    required String email,
    required String dataNascimento,
    required String senha,
    required String confirmarSenha,
    required String nome,
    required String altura,
    required String peso,
    required String cidade,
    required String posicao,
    required String pernaPreferida,
    required String descricao,
  }) {
    if (!isValidEmail(email)) return 'E-mail inválido.';
    if (!isValidBirthDate(dataNascimento)) return 'Data de nascimento inválida.';
    if (senha.length < 6) return 'A senha deve ter ao menos 6 caracteres.';
    if (senha != confirmarSenha) return 'As senhas não coincidem.';
    if (nome.trim().isEmpty) return 'Informe seu nome.';
    if (!isValidAltura(altura)) return 'Altura inválida (ex: 1,80).';
    if (!isValidPeso(peso)) return 'Peso inválido (ex: 75).';
    if (cidade.trim().isEmpty) return 'Informe sua cidade.';
    if (posicao.trim().isEmpty) return 'Selecione sua posição em campo.';
    if (pernaPreferida.trim().isEmpty) return 'Selecione sua perna preferida.';
    if (descricao.trim().isEmpty) return 'Escreva uma breve descrição sobre você.';
    return null;
  }

  void setFotoPerfil(XFile? foto) {
    fotoPerfil = foto;
    notifyListeners();
  }

  Future<String?> cadastrar({
    required String email,
    required String dataNascimento,
    required String senha,
    required String confirmarSenha,
    required String nome,
    required String altura,
    required String peso,
    required String cidade,
    required String posicao,
    required String pernaPreferida,
    required String descricao,
  }) async {
    erro = validar(
      email: email,
      dataNascimento: dataNascimento,
      senha: senha,
      confirmarSenha: confirmarSenha,
      nome: nome,
      altura: altura,
      peso: peso,
      cidade: cidade,
      posicao: posicao,
      pernaPreferida: pernaPreferida,
      descricao: descricao,
    );
    if (erro != null) {
      notifyListeners();
      return erro;
    }

    isLoading = true;
    notifyListeners();

    try {
      final partes = dataNascimento.split('/');
      final dataNasc = DateTime(
        int.parse(partes[2]),
        int.parse(partes[1]),
        int.parse(partes[0]),
      );

      final usuario = UsuarioModel(
        id: '',
        tipo: 'jogador',
        email: email.trim(),
        nome: nome.trim(),
        criadoEm: DateTime.now(),
        dataNascimento: dataNasc,
        altura: double.parse(altura.replaceAll(',', '.')),
        peso: double.parse(peso.replaceAll(',', '.')),
        posicao: posicao,
        cidade: cidade.trim(),
        pernaPreferida: pernaPreferida,
        descricao: descricao.trim(),
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
