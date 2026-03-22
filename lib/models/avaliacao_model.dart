class AvaliacaoModel {
  final String idAvaliacao;
  final String jogadorId;
  final String autorId;
  final String texto;
  final DateTime criadoEm;

  AvaliacaoModel({
    required this.idAvaliacao,
    required this.jogadorId,
    required this.autorId,
    required this.texto,
    required this.criadoEm,
  });

  factory AvaliacaoModel.fromJson(Map<String, dynamic> json) {
    return AvaliacaoModel(
      idAvaliacao: json['id_avaliacao'] ?? '',
      jogadorId: json['jogador_id'] ?? '',
      autorId: json['autor_id'] ?? '',
      texto: json['texto'] ?? '',
      criadoEm: DateTime.parse(json['criado_em']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_avaliacao': idAvaliacao,
      'jogador_id': jogadorId,
      'autor_id': autorId,
      'texto': texto,
      'criado_em': criadoEm.toIso8601String(),
    };
  }
}
