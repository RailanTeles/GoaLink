import 'package:cloud_firestore/cloud_firestore.dart';

class DicaTreinoModel {
  final String idDica;
  final String titulo;
  final String descricao;
  final String? midiaUrl;
  final String categoria;
  final DateTime criadoEm;

  DicaTreinoModel({
    required this.idDica,
    required this.titulo,
    required this.descricao,
    this.midiaUrl,
    required this.categoria,
    required this.criadoEm,
  });

  factory DicaTreinoModel.fromJson(Map<String, dynamic> json) {
    return DicaTreinoModel(
      idDica: json['id_dica'] ?? '',
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'] ?? '',
      midiaUrl: json['midia_url'],
      categoria: json['categoria'] ?? 'Técnico',
      criadoEm: (json['criado_em'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    final dados = {
      'id_dica': idDica,
      'titulo': titulo,
      'descricao': descricao,
      'midia_url': midiaUrl,
      'categoria': categoria,
      'criado_em': Timestamp.fromDate(criadoEm),
    };

    dados.removeWhere((chave, valor) => valor == null);

    return dados;
  }
}
