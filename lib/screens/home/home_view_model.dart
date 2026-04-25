import 'package:flutter/material.dart';
import 'package:goalink/models/postagem_model.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/repositories/postagem_repository.dart';
import 'package:goalink/repositories/usuario_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final PostagemRepository _postagemRepository;
  final UsuarioRepository _usuarioRepository;
  String? erro;
  List<UsuarioModel> jogadoresNovos = [];
  List<PostagemModel> postagens = [];
  bool isLoading = true;
  bool isCarregandoMais = false;
  bool temMaisPostsNoBanco = true;

  HomeViewModel(this._postagemRepository, this._usuarioRepository);

  Future<void> carregarDadosIniciais() async {
    erro = null;
    try {
      if (postagens.isEmpty) {
        isLoading = true;
        postagens = await _postagemRepository.obterFeedLocal();
        notifyListeners();
      }

      jogadoresNovos = await _usuarioRepository.obterJogadoresNovos();
      postagens = await _postagemRepository.obterFeedRemoto();
    } catch (e) {
      erro = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> carregarMaisPosts() async {
    if (isCarregandoMais || !temMaisPostsNoBanco || postagens.isEmpty) {
      return;
    }
    isCarregandoMais = true;
    notifyListeners();
    try {
      DateTime dataDaUltima = postagens.last.criadoEm;
      List<PostagemModel> novosPosts = await _postagemRepository
          .obterFeedRemoto(quantidade: 5, dataUltimoPost: dataDaUltima);
      if (novosPosts.isEmpty) {
        temMaisPostsNoBanco = false;
      } else {
        postagens.addAll(novosPosts);
      }
    } catch (e) {
      throw Exception('Erro ao carregar mais posts: $e');
    } finally {
      isCarregandoMais = false;
      notifyListeners();
    }
  }
}
