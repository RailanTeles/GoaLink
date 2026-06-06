import 'package:flutter/foundation.dart';
import 'package:goalink/models/exercicio_model.dart';
import 'package:goalink/repositories/dica_treino_exercicio_repository.dart';

class ExercicioViewModel extends ChangeNotifier {
  final DicaTreinoExercicioRepository _repository;

  ExercicioViewModel(this._repository);

  List<ExercicioModel> _exercicios = [];
  bool _loading = true;
  String? _error;

  List<ExercicioModel> get exercicios => _exercicios;
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> obterExercicios(String idDica) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _exercicios = await _repository.obterExercicio(idDica);
    } catch (e) {
      _error = 'Erro ao buscar exercícios: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
