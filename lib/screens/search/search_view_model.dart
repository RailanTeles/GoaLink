import 'dart:async';

import 'package:flutter/material.dart';
import 'package:goalink/models/filtros_pesquisa.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/repositories/usuario_repository.dart';

class SearchViewModel extends ChangeNotifier {
  final UsuarioRepository _repository;

  SearchViewModel(this._repository);

  Timer? _debounce;
  bool _isLoading = false;
  String? _erro;
  List<UsuarioModel> _usuarios = [];
  FiltrosPesquisa? _filtrosAtuais;
  String _termoBuscaAtual = '';

  bool get isLoading => _isLoading;
  String? get erro => _erro;
  List<UsuarioModel> get usuarios => _usuarios;
  FiltrosPesquisa? get filtrosAtuais => _filtrosAtuais;
  String get termoBuscaAtual => _termoBuscaAtual;

  void aoDigitar(String texto) {
    _termoBuscaAtual = texto;
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 800), () {
      buscar();
    });
  }

  bool _temFiltroAtivo(FiltrosPesquisa? f) {
    if (f == null) return false;
    return f.tipo != null ||
        f.cidade != null ||
        f.posicao != null ||
        f.pernaPreferida != null ||
        f.pesoMinimo != null ||
        f.pesoMaximo != null ||
        f.alturaMinima != null ||
        f.alturaMaxima != null;
  }

  Future<void> buscar({FiltrosPesquisa? novosFiltros}) async {
    if (novosFiltros != null) {
      _filtrosAtuais = _temFiltroAtivo(novosFiltros) ? novosFiltros : null;
    }

    if (_termoBuscaAtual.isEmpty && _filtrosAtuais == null) {
      _usuarios = [];
      _erro = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _erro = null;
    notifyListeners();

    try {
      _usuarios = await _repository.pesquisarUsuarios(
        termoNome: _termoBuscaAtual.isNotEmpty ? _termoBuscaAtual : null,
        filtros: _filtrosAtuais,
      );
    } catch (e) {
      debugPrint('ERRO DO FIREBASE: $e');
      _erro = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
