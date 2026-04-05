class PostagemModel {
  final String idPostagem;
  final String jogadorId;
  final String midiaUrl;
  final bool isVideo;
  final String? descricao;
  final DateTime criadoEm;

  PostagemModel({
    required this.idPostagem,
    required this.jogadorId,
    required this.midiaUrl,
    this.isVideo = false,
    this.descricao,
    required this.criadoEm,
  });

  factory PostagemModel.fromJson(Map<String, dynamic> json) {
    return PostagemModel(
      idPostagem: json['id_postagem'] ?? '',
      jogadorId: json['jogador_id'] ?? '',
      midiaUrl: json['midia_url'] ?? '',
      isVideo: json['is_video'] ?? false,
      descricao: json['descricao'],
      criadoEm: DateTime.parse(json['criado_em']),
    );
  }

  Map<String, dynamic> toJson() {
    final dados = {
      'id_postagem': idPostagem,
      'jogador_id': jogadorId,
      'midia_url': midiaUrl,
      'is_video': isVideo,
      'descricao': descricao,
      'criado_em': criadoEm.toIso8601String(),
    };

    dados.removeWhere((chave, valor) => valor == null);

    return dados;
  }

  PostagemModel copyWith({
    String? idPostagem,
    String? jogadorId,
    String? midiaUrl,
    bool? isVideo,
    String? descricao,
    DateTime? criadoEm,
  }) {
    return PostagemModel(
      idPostagem: idPostagem ?? this.idPostagem,
      jogadorId: jogadorId ?? this.jogadorId,
      midiaUrl: midiaUrl ?? this.midiaUrl,
      isVideo: isVideo ?? this.isVideo,
      descricao: descricao ?? this.descricao,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }
}
