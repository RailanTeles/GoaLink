import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/postagem_model.dart';

class PostagemService {
  PostagemService._internal();

  static final PostagemService _instance = PostagemService._internal();

  factory PostagemService() => _instance;

  final ValueNotifier<List<PostagemModel>> postagensNotifier =
      ValueNotifier<List<PostagemModel>>([]);

  bool _loaded = false;

  Future<void> ensureLoaded() async {
    if (_loaded) return;

    final response = await rootBundle.loadString('assets/mocks/postagens.json');
    final data = json.decode(response) as List<dynamic>;

    postagensNotifier.value =
        data.map((json) => PostagemModel.fromJson(json)).toList()
          ..sort((a, b) => b.criadoEm.compareTo(a.criadoEm));

    _loaded = true;
  }

  Future<List<PostagemModel>> getFeedPostagens() async {
    await ensureLoaded();
    return postagensNotifier.value;
  }

  Future<List<PostagemModel>> getPostagensByUserId(String jogadorId) async {
    await ensureLoaded();
    return postagensNotifier.value
        .where((post) => post.jogadorId == jogadorId)
        .toList();
  }

  Future<void> criarPostagem(PostagemModel novaPostagem) async {
    await ensureLoaded();
    postagensNotifier.value = [novaPostagem, ...postagensNotifier.value];
  }

  Future<void> atualizarPostagem(PostagemModel postagemAtualizada) async {
    await ensureLoaded();
    postagensNotifier.value =
        postagensNotifier.value
            .map(
              (post) => post.idPostagem == postagemAtualizada.idPostagem
                  ? postagemAtualizada
                  : post,
            )
            .toList()
          ..sort((a, b) => b.criadoEm.compareTo(a.criadoEm));
  }

  Future<void> excluirPostagem(String idPostagem) async {
    await ensureLoaded();
    postagensNotifier.value = postagensNotifier.value
        .where((post) => post.idPostagem != idPostagem)
        .toList();
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
