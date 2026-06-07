import 'package:goalink/models/favorito_model.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/services/favorito_service.dart';

class FavoritoRepository {
  final FavoritoService _service;

  FavoritoRepository(this._service);

  Future<List<FavoritoModel>> obterFavoritos(String uidInteressado) async {
    final docs = await _service.obterFavoritos(uidInteressado);
    final listaFavoritos = docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;

      return FavoritoModel.fromJson(data);
    }).toList();

    return listaFavoritos;
  }

  Future<bool> verificarFavorito(
    String uidInteressado,
    String uidFavorito,
  ) async {
    return await _service.verificarFavorito(uidInteressado, uidFavorito);
  }

  Future<void> adicionarFavorito(
    UsuarioModel meuUsuario,
    UsuarioModel usuarioFavorito,
  ) async {
    final favorito = FavoritoModel(
      id: '',
      idFavorito: usuarioFavorito.id,
      interessadoId: meuUsuario.id,
      nomeFavorito: usuarioFavorito.nome,
      fotoUrlFavorito: usuarioFavorito.fotoUrl,
      criadoEm: DateTime.now(),
    );

    await _service.adicionarFavorito(favorito);
  }

  Future<void> removerFavorito(String meuUsuarioId, String uid) async {
    return await _service.removerFavorito(meuUsuarioId, uid);
  }

  Future<void> deletarFavorito(String docId) async {
    return await _service.deletarFavorito(docId);
  }
}
