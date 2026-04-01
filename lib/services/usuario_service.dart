import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/usuario_model.dart';

class UsuarioService {
  Future<List<UsuarioModel>> _lerTodosUsuarios() async {
    final String response = await rootBundle.loadString(
      'assets/mocks/usuarios.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => UsuarioModel.fromJson(json)).toList();
  }

  Future<List<UsuarioModel>> getJogadores() async {
    final todos = await _lerTodosUsuarios();
    return todos.where((user) => user.tipo == 'jogador').toList();
  }

  Future<UsuarioModel> getJogadorId(String id) async {
    final todos = await _lerTodosUsuarios();
    return todos.firstWhere((user) => user.id == id);
  }

  Future<List<UsuarioModel>> getJogadoresNovos() async {
    final jogadores = await getJogadores();
    final dataLimite = DateTime.now().subtract(const Duration(days: 30));

    return jogadores.where((jogador) {
      return jogador.criadoEm.isAfter(dataLimite);
    }).toList();
  }

  Future<List<UsuarioModel>> getUsuariosPorNome(String query) async {
    // Substitua getUsuarios() pelo método que lê a sua lista completa
    final usuarios = await _lerTodosUsuarios();

    if (query.trim().isEmpty) {
      return usuarios;
    }

    final busca = query.trim().toLowerCase();

    return usuarios.where((usuario) {
      final nomeUsuario = usuario.nome.toLowerCase();

      return nomeUsuario.contains(busca);
    }).toList();
  }
}
