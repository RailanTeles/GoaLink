class PostagemModel {
  final String idPostagem;
  final String jogadorId;
  final String jogadorNome;
  final String? jogadorFotoUrl;
  final String midiaUrl;
  final String tipoMidia;
  final String? descricao;
  final DateTime criadoEm;

  PostagemModel({
    required this.idPostagem,
    required this.jogadorId,
    required this.jogadorNome,
    this.jogadorFotoUrl,
    required this.midiaUrl,
    required this.tipoMidia,
    this.descricao,
    required this.criadoEm,
  });

  factory PostagemModel.fromJson(Map<String, dynamic> json) {
    return PostagemModel(
      idPostagem: json['id_postagem'] ?? '',
      jogadorId: json['jogador_id'] ?? '',
      jogadorNome: json['jogador_nome'] ?? '',
      jogadorFotoUrl: json['jogador_foto_url'],
      midiaUrl: json['midia_url'] ?? '',
      tipoMidia: json['tipo_midia'] ?? '',
      descricao: json['descricao'],
      criadoEm: DateTime.parse(json['criado_em']),
    );
  }

  Map<String, dynamic> toJson() {
    final dados = {
      'id_postagem': idPostagem,
      'jogador_id': jogadorId,
      'jogador_nome': jogadorNome,
      'jogador_foto_url': jogadorFotoUrl,
      'midia_url': midiaUrl,
      'tipo_midia': tipoMidia,
      'descricao': descricao,
      'criado_em': criadoEm.toIso8601String(),
    };

    dados.removeWhere((chave, valor) => valor == null);

    return dados;
  }

  PostagemModel copyWith({
    String? idPostagem,
    String? jogadorId,
    String? jogadorNome,
    String? jogadorFotoUrl,
    String? midiaUrl,
    String? tipoMidia,
    String? descricao,
    DateTime? criadoEm,
  }) {
    return PostagemModel(
      idPostagem: idPostagem ?? this.idPostagem,
      jogadorId: jogadorId ?? this.jogadorId,
      jogadorNome: jogadorNome ?? this.jogadorNome,
      jogadorFotoUrl: jogadorFotoUrl ?? this.jogadorFotoUrl,
      midiaUrl: midiaUrl ?? this.midiaUrl,
      tipoMidia: tipoMidia ?? this.tipoMidia,
      descricao: descricao ?? this.descricao,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }
}
