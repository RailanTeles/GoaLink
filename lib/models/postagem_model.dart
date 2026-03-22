class PostagemModel {
  final String idPostagem;
  final String jogadorId;
  final String midiaUrl;
  final String? descricao;
  final DateTime criadoEm;

  PostagemModel({
    required this.idPostagem,
    required this.jogadorId,
    required this.midiaUrl,
    this.descricao,
    required this.criadoEm,
  });

  factory PostagemModel.fromJson(Map<String, dynamic> json) {
    return PostagemModel(
      idPostagem: json['id_postagem'] ?? '',
      jogadorId: json['jogador_id'] ?? '',
      midiaUrl: json['midia_url'] ?? '',
      descricao: json['descricao'],
      criadoEm: DateTime.parse(json['criado_em']),
    );
  }

  Map<String, dynamic> toJson() {
    final dados = {
      'id_postagem': idPostagem,
      'jogador_id': jogadorId,
      'midia_url': midiaUrl,
      'descricao': descricao,
      'criado_em': criadoEm.toIso8601String(),
    };

    dados.removeWhere((chave, valor) => valor == null);

    return dados;
  }
}
