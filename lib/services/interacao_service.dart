import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/avaliacao_model.dart';
// import '../models/favorito_model.dart';

class InteracaoService {
  // Requisito: Comentar no perfil do atleta
  Future<void> enviarAvaliacao(AvaliacaoModel avaliacao) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Traz as avaliações de um jogador específico para desenhar no perfil dele
  Future<List<AvaliacaoModel>> getAvaliacoesDoJogador(String idJogador) async {
    final String response = await rootBundle.loadString(
      'assets/mocks/avaliacoes.json',
    );
    final List<dynamic> data = json.decode(response);

    final todasAvaliacoes = data
        .map((json) => AvaliacaoModel.fromJson(json))
        .toList();

    // Filtra para retornar apenas as avaliações deste jogador
    return todasAvaliacoes.where((av) => av.jogadorId == idJogador).toList();
  }

  // Requisito: Favoritar jogador
  Future<void> favoritarJogador(String idOlheiro, String idJogador) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
