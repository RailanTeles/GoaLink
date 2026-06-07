import 'package:flutter/material.dart';
import 'package:goalink/core/contracts/post_coment_controller.dart';
import 'package:goalink/models/avaliacao_model.dart';
import 'package:goalink/models/postagem_model.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/repositories/avaliacoes_repository.dart';
import 'package:goalink/repositories/favorito_repository.dart';
import 'package:goalink/repositories/postagem_repository.dart';
import 'package:goalink/repositories/usuario_repository.dart';

class ProfilesViewModel extends ChangeNotifier implements PostComentController {
  final UsuarioRepository _usuarioRepository;
  final PostagemRepository _postagemRepository;
  final AvaliacoesRepository _avaliacoesRepository;
  final FavoritoRepository _favoritoRepository;

  ProfilesViewModel(
    this._usuarioRepository,
    this._postagemRepository,
    this._avaliacoesRepository,
    this._favoritoRepository,
  );

  UsuarioModel? _usuario;
  UsuarioModel? _meuUsuario;
  List<PostagemModel> _postagens = [];
  List<AvaliacaoModel> _avaliacoes = [];
  bool _isLoadingPerfil = true;
  bool _isLoadingPostagens = true;
  bool _isLoadingAvaliacoes = true;
  String? _erro;
  String? _erroPostagens;
  String? _erroAvaliacoes;
  bool _isFavorito = false;
  bool _isLoadingFavoritar = false;
  bool _isLoadingComentar = false;

  String? _erroSnackBar;
  String? _sucessoSnackBar;

  String? get erroSnackBar => _erroSnackBar;
  String? get sucessoSnackBar => _sucessoSnackBar;
  UsuarioModel? get usuario => _usuario;
  UsuarioModel? get meuUsuario => _meuUsuario;
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
  bool get isFavorito => _isFavorito;
  bool get isLoadingFavoritar => _isLoadingFavoritar;
  bool get isLoadingComentar => _isLoadingComentar;

  Future<void> carregarDadosInicias(String uid) async {
    _isLoadingPerfil = true;
    notifyListeners();

    try {
      _usuario = await _usuarioRepository.obterUsuarioPorUid(uid);
      _meuUsuario = await _usuarioRepository.obterUsuarioLogado();

      _isFavorito = await _favoritoRepository.verificarFavorito(
        _meuUsuario!.id,
        uid,
      );
    } catch (e) {
      _erro = "$e".replaceAll("Exception: ", "");
    } finally {
      _isLoadingPerfil = false;
      notifyListeners();
    }
  }

  Future<void> obterComentarios(String uid) async {
    _isLoadingAvaliacoes = true;
    notifyListeners();

    try {
      _avaliacoes = await _avaliacoesRepository.obterAvaliacoesUsuario(uid);
    } catch (e) {
      _erroAvaliacoes = "$e".replaceAll("Exception: ", "");
    } finally {
      _isLoadingAvaliacoes = false;
      notifyListeners();
    }
  }

  Future<void> obterPostagens(String uid) async {
    _isLoadingPostagens = true;
    notifyListeners();

    try {
      _postagens = await _postagemRepository.obterPostagensUsuarioPorId(uid);
    } catch (e) {
      _erroPostagens = "$e".replaceAll("Exception: ", "");
    } finally {
      _isLoadingPostagens = false;
      notifyListeners();
    }
  }

  Future<void> fazerComentario(String uid, String texto) async {
    _isLoadingComentar = true;
    _erroSnackBar = null;
    _sucessoSnackBar = null;
    notifyListeners();

    try {
      await _avaliacoesRepository.adicionarAvaliacao(
        _meuUsuario!,
        _usuario!,
        texto,
      );
      await obterComentarios(uid);
      _sucessoSnackBar = "Comentário adicionado com sucesso!";
    } catch (e) {
      _erroSnackBar = "$e".replaceAll("Exception: ", "");
    } finally {
      _isLoadingComentar = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorito(String uid) async {
    if (_usuario == null || _meuUsuario == null) return;

    _isLoadingFavoritar = true;
    notifyListeners();

    try {
      if (_isFavorito) {
        await _favoritoRepository.removerFavorito(
          _meuUsuario!.id,
          _usuario!.id,
        );
      } else {
        await _favoritoRepository.adicionarFavorito(_meuUsuario!, _usuario!);
      }

      _isFavorito = !_isFavorito;
      _sucessoSnackBar = _isFavorito
          ? "Usuário adicionado aos favoritos com sucesso!"
          : "Usuário removido dos favoritos com sucesso!";
    } catch (e) {
      _erroSnackBar = "$e".replaceAll("Exception: ", "");
    } finally {
      _isLoadingFavoritar = false;
      notifyListeners();
    }
  }

  String gerarIdDoChat(String meuUid, String outroUid) {
    return meuUid.compareTo(outroUid) < 0
        ? '${meuUid}_$outroUid'
        : '${outroUid}_$meuUid';
  }
}
