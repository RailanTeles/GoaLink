import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:goalink/models/avaliacao_model.dart';

class AvaliacaoService {
  Future<List<AvaliacaoModel>> getAvaliacoesByJogadorId(
    String jogadorId,
  ) async {
    final jsonString = await rootBundle.loadString(
      'assets/mocks/avaliacoes.json',
    );
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;

    final avaliacoes = jsonList
        .map((item) => AvaliacaoModel.fromJson(item as Map<String, dynamic>))
        .where((avaliacao) => avaliacao.jogadorId == jogadorId)
        .toList();

    avaliacoes.sort((a, b) => b.criadoEm.compareTo(a.criadoEm));
    return avaliacoes;
  }
}
