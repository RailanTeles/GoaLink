import 'package:flutter/material.dart';
import 'package:goalink/models/favorito_model.dart';
import 'package:goalink/repositories/favorito_repository.dart';

class FavoriteViewModel extends ChangeNotifier {
  final FavoritoRepository _repository;

  FavoriteViewModel(this._repository);

  String? _erro;
  bool _isLoading = true;
  String? _erroSnackBar;
  List<FavoritoModel>? _favoritos;
  final Set<String> _idsEmRemocao = {};

  String? get erro => _erro;
  bool get isLoading => _isLoading;
  String? get erroSnackBar => _erroSnackBar;
  List<FavoritoModel>? get favoritos => _favoritos;
  bool isRemovendo(String docId) => _idsEmRemocao.contains(docId);

  Future<void> obterFavoritos(String uid) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();

    try {
      _favoritos = await _repository.obterFavoritos(uid);
    } catch (e) {
      _erro = "$e".replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removerFavorito(String docId) async {
    if (_favoritos == null) return;

    if (_idsEmRemocao.contains(docId)) return;

    _erroSnackBar = null;
    _idsEmRemocao.add(docId);
    notifyListeners();

    try {
      await _repository.deletarFavorito(docId);
      _favoritos?.removeWhere((favorito) => favorito.id == docId);
    } catch (e) {
      _erroSnackBar = "$e".replaceAll('Exception: ', '');
    } finally {
      _idsEmRemocao.remove(docId);
      notifyListeners();
    }
  }
}
