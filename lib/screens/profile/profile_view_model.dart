import 'package:flutter/foundation.dart';
import 'package:goalink/core/contracts/post_coment_controller.dart';
import 'package:goalink/models/avaliacao_model.dart';
import 'package:goalink/models/postagem_model.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/repositories/avaliacoes_repository.dart';
import 'package:goalink/repositories/postagem_repository.dart';
import 'package:goalink/repositories/usuario_repository.dart';

class ProfileViewModel extends ChangeNotifier implements PostComentController {
  final PostagemRepository _postagemRepository;
  final UsuarioRepository _usuarioRepository;
  final AvaliacoesRepository _avaliacoesRepository;

  UsuarioModel? _usuario;
  List<PostagemModel> _postagens = [];
  List<AvaliacaoModel> _avaliacoes = [];
  bool _isLoadingPerfil = true;
  bool _isLoadingPostagens = true;
  bool _isLoadingAvaliacoes = true;
  bool _isLoadingDeletarPostagem = false;
  String? _erro;
  String? _erroPostagens;
  String? _erroAvaliacoes;
  String? _erroDeletarPostagem;

  UsuarioModel? get usuario => _usuario;
  @override
  List<PostagemModel> get postagens => _postagens;
  @override
  List<AvaliacaoModel> get avaliacoes => _avaliacoes;
  bool get isLoadingPerfil => _isLoadingPerfil;
  @override
  bool get isLoadingPostagens => _isLoadingPostagens;
  @override
  bool get isLoadingAvaliacoes => _isLoadingAvaliacoes;
  String? get erro => _erro;
  @override
  String? get erroPostagens => _erroPostagens;
  @override
  String? get erroAvaliacoes => _erroAvaliacoes;
  String? get erroDeletarPostagem => _erroDeletarPostagem;
  bool get isLoadingDeletarPostagem => _isLoadingDeletarPostagem;

  ProfileViewModel(
    this._postagemRepository,
    this._usuarioRepository,
    this._avaliacoesRepository,
  );

  Future<void> obterInformacoesPerfil() async {
    _erro = null;

    _isLoadingPerfil = true;
    notifyListeners();
    try {
      _usuario = await _usuarioRepository.obterUsuarioLogado();
    } catch (e) {
      _erro = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingPerfil = false;
      notifyListeners();
    }
  }

  Future<void> obterPostagensUsuario() async {
    _erroPostagens = null;
    _isLoadingPostagens = true;
    notifyListeners();
    try {
      _postagens = await _postagemRepository.obterPostagensUsuarioPorId(
        _usuario!.id,
      );
    } catch (e) {
      _erroPostagens = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingPostagens = false;
      notifyListeners();
    }
  }

  Future<void> obterAvaliacoesUsuario() async {
    _erroAvaliacoes = null;
    _isLoadingAvaliacoes = true;
    notifyListeners();
    try {
      _avaliacoes = await _avaliacoesRepository.obterAvaliacoesUsuario(
        _usuario!.id,
      );
    } catch (e) {
      _erroAvaliacoes = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingAvaliacoes = false;
      notifyListeners();
    }
  }

  Future<void> carregarDadosIniciais() async {
    await obterInformacoesPerfil();
    if (_usuario != null) {
      await Future.wait([obterPostagensUsuario(), obterAvaliacoesUsuario()]);
    }
  }

  Future<void> deletarPostagem(PostagemModel postagem) async {
    _isLoadingDeletarPostagem = true;
    notifyListeners();
    try {
      await _postagemRepository.deletarPostagem(postagem);
      _postagens.remove(postagem);
    } catch (e) {
      _erroDeletarPostagem = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingDeletarPostagem = false;
      notifyListeners();
    }
  }
}
