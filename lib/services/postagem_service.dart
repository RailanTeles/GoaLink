import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/postagem_model.dart';

class PostagemService {
  Future<List<PostagemModel>> getFeedPostagens() async {
    await Future.delayed(const Duration(milliseconds: 800));
    final String response = await rootBundle.loadString(
      'assets/mocks/postagens.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => PostagemModel.fromJson(json)).toList();
  }

  Future<void> criarPostagem(PostagemModel novaPostagem) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> excluirPostagem(String idPostagem) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<List<PostagemModel>> getPostagensByUserID(String userId) async {
    await Future.delayed(
      const Duration(milliseconds: 800),
    ); // Mantém a simulação de delay

    final String response = await rootBundle.loadString(
      'assets/mocks/postagens.json',
    );

    final List<dynamic> data = json.decode(response);

    return data
        .map((json) => PostagemModel.fromJson(json))
        .where(
          (postagem) => postagem.jogadorId == userId,
        ) // Filtra pelo ID recebido
        .toList();
  }
}
