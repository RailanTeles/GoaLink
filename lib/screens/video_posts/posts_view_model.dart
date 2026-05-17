import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/repositories/postagem_repository.dart';
import 'package:goalink/services/cache_service.dart';

class PostsViewModel extends ChangeNotifier {
  final PostagemRepository _postagemRepository;
  final CacheService _cacheService;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  PostsViewModel(this._postagemRepository, this._cacheService);

  Future<void> fazerPostagem({
    required String caminhoArquivo,
    String? descricao,
  }) async {
    if (_isUploading) return;

    _isUploading = true;
    notifyListeners();

    UsuarioModel? usuario = await _cacheService.buscarPerfilLocal();
    if (usuario == null) {
      throw Exception('Usuário não encontrado');
    }

    try {
      await _postagemRepository.fazerPostagem(
        usuario,
        caminhoArquivo,
        descricao,
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}
