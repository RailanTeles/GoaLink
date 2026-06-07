import 'package:goalink/models/avaliacao_model.dart';
import 'package:goalink/models/usuario_model.dart';
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

  Future<void> adicionarAvaliacao(
    UsuarioModel meuUsuario,
    UsuarioModel usuarioAvaliado,
    String texto,
  ) async {
    final avaliacao = AvaliacaoModel(
      idAvaliacao: '',
      jogadorId: usuarioAvaliado.id,
      autorId: meuUsuario.id,
      autorEmail: meuUsuario.email,
      autorFotoUrl: meuUsuario.fotoUrl,
      texto: texto,
      criadoEm: DateTime.now(),
    );

    await _avaliacaoService.adicionarAvaliacao(avaliacao);
  }
}
