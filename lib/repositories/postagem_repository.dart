import 'package:goalink/models/postagem_model.dart';
import 'package:goalink/services/cache_service.dart';
import 'package:goalink/services/postagem_service.dart';

class PostagemRepository {
  final PostagemService postagemService;
  final CacheService cacheService;

  PostagemRepository(this.postagemService, this.cacheService);

  Future<List<PostagemModel>> obterFeedLocal() async {
    return await cacheService.buscarPostagensLocal();
  }

  Future<List<PostagemModel>> obterFeedRemoto({
    int quantidade = 5,
    DateTime? dataUltimoPost,
  }) async {
    List<PostagemModel> postagensNovas = await postagemService
        .obterPostagensFeed(
          quantidade: quantidade,
          dataUltimoPost: dataUltimoPost,
        );

    if (postagensNovas.isNotEmpty) {
      await cacheService.salvarPostagensLocal(postagensNovas);
    }

    return postagensNovas;
  }
}
