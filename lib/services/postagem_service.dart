import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/postagem_model.dart';

class PostagemService {
  // Traz o feed para a tela inicial
  Future<List<PostagemModel>> getFeedPostagens() async {
    await Future.delayed(const Duration(milliseconds: 800));
    final String response = await rootBundle.loadString(
      'assets/mocks/postagens.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => PostagemModel.fromJson(json)).toList();
  }

  // Simula a criação de uma postagem
  Future<void> criarPostagem(PostagemModel novaPostagem) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  // Requisito: Excluir próprio conteúdo
  Future<void> excluirPostagem(String idPostagem) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
