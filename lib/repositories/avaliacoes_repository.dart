import 'package:goalink/models/avaliacao_model.dart';
import 'package:goalink/services/avaliacao_service.dart';

class AvaliacoesRepository {
  final AvaliacaoService _avaliacaoService;

  AvaliacoesRepository(this._avaliacaoService);

  Future<List<AvaliacaoModel>> obterAvaliacoesUsuario(String uid) async {
    final docs = await _avaliacaoService.obterAvaliacoesUsuario(uid);

    final avaliacoes = docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;

      return AvaliacaoModel.fromJson(data);
    }).toList();

    return avaliacoes;
  }
}
