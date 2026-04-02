import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/chat_model.dart';
import '../models/dica_treino_model.dart';
import '../models/exercicio_model.dart';

class ComunicacaoService {
  Future<List<ChatModel>> getChatsDoUsuario(String idUsuarioLogado) async {
    final String response = await rootBundle.loadString(
      'assets/mocks/chats.json',
    );
    final List<dynamic> data = json.decode(response);

    final todosChats = data.map((json) => ChatModel.fromJson(json)).toList();

    // Traz só as conversas onde o usuário faz parte dos participantes
    return todosChats
        .where((chat) => chat.participantes.contains(idUsuarioLogado))
        .toList();
  }

  // Requisito: Enviar mensagem
  Future<void> enviarMensagem(String idChat, MensagemModel mensagem) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Requisito: Dicas de treino
  Future<List<DicaTreinoModel>> getDicasTreino() async {
    final String response = await rootBundle.loadString(
      'assets/mocks/dicas_treinos.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => DicaTreinoModel.fromJson(json)).toList();
  }

  // Requisito: Exercícios
  Future<List<ExercicioModel>> getExercicios() async {
    final String response = await rootBundle.loadString(
      'assets/mocks/exercicios.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => ExercicioModel.fromJson(json)).toList();
  }
}
