class FavoritoModel {
  final String id;
  final String idFavorito;
  final String interessadoId;
  final String nomeFavorito;
  final String? fotoUrlFavorito;
  final DateTime criadoEm;

  FavoritoModel({
    required this.id,
    required this.idFavorito,
    required this.interessadoId,
    required this.nomeFavorito,
    this.fotoUrlFavorito,
    required this.criadoEm,
  });

  factory FavoritoModel.fromJson(Map<String, dynamic> json) {
    return FavoritoModel(
      id: json['id'],
      idFavorito: json['id_favorito'] ?? '',
      interessadoId: json['interessado_id'] ?? '',
      nomeFavorito: json['nome_favorito'] ?? '',
      fotoUrlFavorito: json['foto_url_favorito'],
      criadoEm: DateTime.parse(json['criado_em']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_favorito': idFavorito,
      'interessado_id': interessadoId,
      'nome_favorito': nomeFavorito,
      'foto_url_favorito': fotoUrlFavorito,
      'criado_em': criadoEm.toIso8601String(),
    };
  }
}
