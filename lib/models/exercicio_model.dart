class ExercicioModel {
  final String idExercicio;
  final String idDica;
  final String titulo;
  final String descricao;
  final String? midiaUrl;
  final String? videoUrl;
  final String categoria;
  final DateTime criadoEm;

  ExercicioModel({
    required this.idExercicio,
    required this.idDica,
    required this.titulo,
    required this.descricao,
    this.midiaUrl,
    this.videoUrl,
    required this.categoria,
    required this.criadoEm,
  });

  factory ExercicioModel.fromJson(Map<String, dynamic> json) {
    return ExercicioModel(
      idExercicio: json['id_exercicio'] ?? '',
      idDica: json['id_dica'] ?? '',
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'] ?? '',
      midiaUrl: json['midia_url'],
      videoUrl: json['video_url'],
      categoria: json['categoria'] ?? 'Técnico',
      criadoEm: DateTime.parse(json['criado_em']),
    );
  }

  Map<String, dynamic> toJson() {
    final dados = {
      'id_exercicio': idExercicio,
      'id_dica': idDica,
      'titulo': titulo,
      'descricao': descricao,
      'midia_url': midiaUrl,
      'video_url': videoUrl,
      'categoria': categoria,
      'criado_em': criadoEm.toIso8601String(),
    };

    dados.removeWhere((chave, valor) => valor == null);

    return dados;
  }
}
