import 'package:goalink/models/postagem_model.dart';
import 'package:goalink/services/cache_service.dart';
import 'package:goalink/services/postagem_service.dart';

class PostagemRepository {
  final PostagemService postagemService;
  final CacheService cacheService;

  PostagemRepository({
    required this.postagemService,
    required this.cacheService,
  });

  Future<List<PostagemModel>> obterFeedLocal() async {
    return await cacheService.buscarPostagensLocal();
  }

  Future<List<PostagemModel>> obterFeedRemoto() async {
    List<PostagemModel> postagensNovas = await postagemService
        .obterPostagensFeed();
    if (postagensNovas.isNotEmpty) {
      await cacheService.salvarPostagensLocal(postagensNovas);
    }

    return postagensNovas;
  }
}
