class FavoritoModel {
  final String idFavorito;
  final String interessadoId;
  final String jogadorId;
  final DateTime criadoEm;

  FavoritoModel({
    required this.idFavorito,
    required this.interessadoId,
    required this.jogadorId,
    required this.criadoEm,
  });

  factory FavoritoModel.fromJson(Map<String, dynamic> json) {
    return FavoritoModel(
      idFavorito: json['id_favorito'] ?? '',
      interessadoId: json['interessado_id'] ?? '',
      jogadorId: json['jogador_id'] ?? '',
      criadoEm: DateTime.parse(json['criado_em']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_favorito': idFavorito,
      'interessado_id': interessadoId,
      'jogador_id': jogadorId,
      'criado_em': criadoEm.toIso8601String(),
    };
  }
}
