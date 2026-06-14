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
    temMaisPostsNoBanco = true;
    try {
      if (postagens.isEmpty) {
        isLoading = true;
        postagens = await _postagemRepository.obterFeedLocal();
        notifyListeners();
      }

      jogadoresNovos = await _usuarioRepository.obterJogadoresNovos();

      postagens = await _postagemRepository.obterFeedRemoto(reiniciar: true);
    } catch (e) {
      erro = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> carregarMaisPosts() async {
    if (isCarregandoMais || !temMaisPostsNoBanco || postagens.isEmpty) return;

    isCarregandoMais = true;
    notifyListeners();

    try {
      final novosPosts = await _postagemRepository.obterFeedRemoto(
        quantidade: 5,
      );

      if (novosPosts.isEmpty) {
        temMaisPostsNoBanco = false;
      } else {
        postagens.addAll(novosPosts);
      }
    } catch (e) {
      erro = e.toString().replaceAll('Exception: ', '');
    } finally {
      isCarregandoMais = false;
      notifyListeners();
    }
  }
}
