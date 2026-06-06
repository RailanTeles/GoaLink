import 'package:goalink/models/dica_treino_model.dart';
import 'package:goalink/models/exercicio_model.dart';
import 'package:goalink/services/dica_treino_exercicio_service.dart';

class DicaTreinoExercicioRepository {
  final DicaTreinoExercicioService _dicaTreinoExercicioService;

  DicaTreinoExercicioRepository(this._dicaTreinoExercicioService);

  Future<List<DicaTreinoModel>> obterDicasTreino() async {
    final docs = await _dicaTreinoExercicioService.obterDicasTreino();

    final dicas = docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id_dica'] = doc.id;

      return DicaTreinoModel.fromJson(data);
    }).toList();

    return dicas;
  }

  Future<List<ExercicioModel>> obterExercicio(String idDica) async {
    final docs = await _dicaTreinoExercicioService.obterExercicio(idDica);

    final exercicios = docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id_exercicio'] = doc.id;

      return ExercicioModel.fromJson(data);
    }).toList();

    return exercicios;
  }
}
