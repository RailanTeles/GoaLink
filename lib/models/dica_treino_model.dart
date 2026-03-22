class DicaTreinoModel {
  final String idDica;
  final String titulo;
  final String descricao;
  final String? midiaUrl;
  final DateTime criadoEm;

  DicaTreinoModel({
    required this.idDica,
    required this.titulo,
    required this.descricao,
    this.midiaUrl,
    required this.criadoEm,
  });

  factory DicaTreinoModel.fromJson(Map<String, dynamic> json) {
    return DicaTreinoModel(
      idDica: json['id_dica'] ?? '',
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'] ?? '',
      midiaUrl: json['midia_url'],
      criadoEm: DateTime.parse(json['criado_em']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_dica': idDica,
      'titulo': titulo,
      'descricao': descricao,
      'midia_url': midiaUrl,
      'criado_em': criadoEm.toIso8601String(),
    };
  }
}
