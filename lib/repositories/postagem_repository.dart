import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goalink/models/postagem_model.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/services/cache_service.dart';
import 'package:goalink/services/postagem_service.dart';
import 'package:goalink/services/storage_service.dart';
import 'package:mime/mime.dart';

class PostagemRepository {
  final PostagemService postagemService;
  final CacheService cacheService;
  final StorageService storageService;

  DocumentSnapshot? _ultimoDoc;

  PostagemRepository(
    this.postagemService,
    this.cacheService,
    this.storageService,
  );

  Future<List<PostagemModel>> obterFeedLocal() async {
    return await cacheService.buscarPostagensLocal();
  }

  Future<List<PostagemModel>> obterFeedRemoto({
    int quantidade = 5,
    bool reiniciar = false,
  }) async {
    if (reiniciar) _ultimoDoc = null;

    final docs = await postagemService.obterPostagensFeed(
      quantidade: quantidade,
      ultimoDoc: _ultimoDoc,
    );

    if (docs.isNotEmpty) {
      _ultimoDoc = docs.last;
    }

    final postagens = docs
        .map(
          (doc) => PostagemModel.fromJson(doc.data() as Map<String, dynamic>),
        )
        .toList();

    if (postagens.isNotEmpty) {
      await cacheService.salvarPostagensLocal(postagens);
    }

    return postagens;
  }

  Future<void> fazerPostagem(
    UsuarioModel usuario,
    String caminhoArquivo,
    String? descricao,
  ) async {
    final String refUid = await postagemService.criarRefPostagem();
    String? urlMidia;
    try {
      urlMidia = await storageService.uploadMidiaPostagem(
        idPostagem: refUid,
        caminhoLocal: caminhoArquivo,
      );
      String? mimeCompleto = lookupMimeType(caminhoArquivo);

      String tipoMidia = mimeCompleto?.split('/')[0] ?? 'image';

      final postagem = PostagemModel(
        idPostagem: refUid,
        jogadorId: usuario.id,
        jogadorNome: usuario.nome,
        jogadorFotoUrl: usuario.fotoUrl,
        midiaUrl: urlMidia,
        tipoMidia: tipoMidia,
        descricao: descricao,
        criadoEm: DateTime.now(),
      );
      await postagemService.criarPostagem(postagem);
    } catch (e) {
      if (urlMidia != null) {
        await storageService.deletarMidia(urlMidia);
      }
      throw Exception('Erro ao fazer postagem: $e');
    }
  }
}
