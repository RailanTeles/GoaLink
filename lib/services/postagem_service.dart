import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/postagem_model.dart';

class PostagemService {
  Future<List<PostagemModel>> _lerPostagensDoJson() async {
    final response = await rootBundle.loadString('assets/mocks/postagens.json');
    final data = json.decode(response) as List<dynamic>;

    final lista = data.map((json) => PostagemModel.fromJson(json)).toList()
      ..sort((a, b) => b.criadoEm.compareTo(a.criadoEm));

    return lista;
  }

  Future<List<PostagemModel>> getFeedPostagens() async {
    return _lerPostagensDoJson();
  }

  Future<List<PostagemModel>> getPostagensByUserId(String jogadorId) async {
    final postagens = await _lerPostagensDoJson();
    return postagens.where((post) => post.jogadorId == jogadorId).toList();
  }

  Future<void> criarPostagem(PostagemModel novaPostagem) async {
    final postagens = await _lerPostagensDoJson();
    postagens.insert(0, novaPostagem);
  }

  Future<void> atualizarPostagem(PostagemModel postagemAtualizada) async {
    final postagens = await _lerPostagensDoJson();
    final index = postagens.indexWhere(
      (post) => post.idPostagem == postagemAtualizada.idPostagem,
    );

    if (index == -1) {
      return;
    }

    postagens[index] = postagemAtualizada;
    postagens.sort((a, b) => b.criadoEm.compareTo(a.criadoEm));
  }

  Future<void> excluirPostagem(String idPostagem) async {
    final postagens = await _lerPostagensDoJson();
    postagens.removeWhere((post) => post.idPostagem == idPostagem);
  }

  Future<List<PostagemModel>> getPostagensByUserID(String userId) async {
    await Future.delayed(
      const Duration(milliseconds: 800),
    ); // Mantém a simulação de delay

    final postagens = await _lerPostagensDoJson();
    return postagens.where((postagem) => postagem.jogadorId == userId).toList();
  }
}
