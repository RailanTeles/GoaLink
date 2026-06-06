import 'package:flutter/foundation.dart';
import 'package:goalink/models/dica_treino_model.dart';
import 'package:goalink/repositories/dica_treino_exercicio_repository.dart';

class TipsViewModel extends ChangeNotifier {
  DicaTreinoExercicioRepository _repository;

  TipsViewModel(this._repository);

  List<DicaTreinoModel> _dicasTreino = [];
  bool _loading = true;
  String? _error;
  String _filtroAtual = 'Todos';

  List<DicaTreinoModel> get dicasTreino => _dicasTreino;
  bool get isLoading => _loading;
  String? get error => _error;
  String get filtroAtual => _filtroAtual;
  List<DicaTreinoModel> get dicasFiltradas {
    if (_filtroAtual == 'Todos') return _dicasTreino;
    return _dicasTreino
        .where((dica) => dica.categoria == _filtroAtual)
        .toList();
  }

  Future<void> obterDicas() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _dicasTreino = await _repository.obterDicasTreino();
    } catch (e) {
      _error = 'Erro ao buscar dicas: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void alterarFiltro(String novoFiltro) {
    if (_filtroAtual == novoFiltro) return;
    _filtroAtual = novoFiltro;
    notifyListeners();
  }
}
