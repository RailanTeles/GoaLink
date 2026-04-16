class AvaliacaoModel {
  final String idAvaliacao;
  final String jogadorId;
  final String autorId;
  final String autorEmail;
  final String? autorFotoUrl;
  final String texto;
  final DateTime criadoEm;

  AvaliacaoModel({
    required this.idAvaliacao,
    required this.jogadorId,
    required this.autorId,
    required this.autorEmail,
    this.autorFotoUrl,
    required this.texto,
    required this.criadoEm,
  });

  factory AvaliacaoModel.fromJson(Map<String, dynamic> json) {
    return AvaliacaoModel(
      idAvaliacao: json['id_avaliacao'] ?? '',
      jogadorId: json['jogador_id'] ?? '',
      autorId: json['autor_id'] ?? '',
      autorEmail: json['autor_email'] ?? '',
      autorFotoUrl: json['autor_foto_url'],
      texto: json['texto'] ?? '',
      criadoEm: DateTime.parse(json['criado_em']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_avaliacao': idAvaliacao,
      'jogador_id': jogadorId,
      'autor_id': autorId,
      'autor_email': autorEmail,
      'autor_foto_url': autorFotoUrl,
      'texto': texto,
      'criado_em': criadoEm.toIso8601String(),
    };
  }

  AvaliacaoModel copyWith({
    String? idAvaliacao,
    String? jogadorId,
    String? autorId,
    String? autorEmail,
    String? autorFotoUrl,
    String? texto,
    DateTime? criadoEm,
  }) {
    return AvaliacaoModel(
      idAvaliacao: idAvaliacao ?? this.idAvaliacao,
      jogadorId: jogadorId ?? this.jogadorId,
      autorId: autorId ?? this.autorId,
      autorEmail: autorEmail ?? this.autorEmail,
      autorFotoUrl: autorFotoUrl ?? this.autorFotoUrl,
      texto: texto ?? this.texto,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }
}
