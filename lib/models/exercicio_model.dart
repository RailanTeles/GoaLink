import 'package:cloud_firestore/cloud_firestore.dart';

class ExercicioModel {
  final String idExercicio;
  final String titulo;
  final String descricao;
  final String? videoUrl;
  final String categoria;
  final DateTime criadoEm;

  ExercicioModel({
    required this.idExercicio,
    required this.titulo,
    required this.descricao,
    this.videoUrl,
    required this.categoria,
    required this.criadoEm,
  });

  factory ExercicioModel.fromJson(Map<String, dynamic> json) {
    return ExercicioModel(
      idExercicio: json['id_exercicio'] ?? '',
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'] ?? '',
      videoUrl: json['video_url'],
      categoria: json['categoria'] ?? 'Técnico',
      criadoEm: (json['criado_em'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    final dados = {
      'id_exercicio': idExercicio,
      'titulo': titulo,
      'descricao': descricao,
      'video_url': videoUrl,
      'categoria': categoria,
      'criado_em': Timestamp.fromDate(criadoEm),
    };

    dados.removeWhere((chave, valor) => valor == null);

    return dados;
  }
}
