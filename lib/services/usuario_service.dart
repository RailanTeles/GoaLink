import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/usuario_model.dart';

class UsuarioService {
  // Função auxiliar privada para ler o JSON geral
  Future<List<UsuarioModel>> _lerTodosUsuarios() async {
    final String response = await rootBundle.loadString(
      'assets/mocks/usuarios.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => UsuarioModel.fromJson(json)).toList();
  }

  // Traz APENAS jogadores
  Future<List<UsuarioModel>> getJogadores() async {
    final todos = await _lerTodosUsuarios();
    return todos.where((user) => user.tipo == 'jogador').toList();
  }

  Future<UsuarioModel> getJogadorId(String id) async {
    final todos = await _lerTodosUsuarios();
    return todos.firstWhere((user) => user.id == id);
  }

  // Requisito: Traz "Jogadores Novos" (Criados nos últimos 30 dias)
  Future<List<UsuarioModel>> getJogadoresNovos() async {
    final jogadores = await getJogadores();
    final dataLimite = DateTime.now().subtract(const Duration(days: 30));

    return jogadores.where((jogador) {
      // Verifica se a data de criação é depois (isAfter) da data limite
      return jogador.criadoEm.isAfter(dataLimite);
    }).toList();
  }

  // Requisito: Busca de atletas com filtros (Posição e Cidade)
  Future<List<UsuarioModel>> buscarJogadores({
    String? posicao,
    String? cidade,
  }) async {
    var jogadores = await getJogadores();

    if (posicao != null && posicao.isNotEmpty) {
      jogadores = jogadores
          .where((j) => j.posicao?.toLowerCase() == posicao.toLowerCase())
          .toList();
    }

    if (cidade != null && cidade.isNotEmpty) {
      jogadores = jogadores
          .where((j) => j.cidade?.toLowerCase() == cidade.toLowerCase())
          .toList();
    }

    return jogadores;
  }
}
