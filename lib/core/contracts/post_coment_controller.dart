import 'package:goalink/models/avaliacao_model.dart';
import 'package:goalink/models/postagem_model.dart';

abstract class PostComentController {
  List<PostagemModel> get postagens;
  List<AvaliacaoModel> get avaliacoes;
  bool get isLoadingPostagens;
  bool get isLoadingAvaliacoes;
  String? get erroPostagens;
  String? get erroAvaliacoes;
}
