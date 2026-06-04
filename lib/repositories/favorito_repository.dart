import 'package:goalink/models/favorito_model.dart';
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

  Future<void> deletarFavorito(String docId) async {
    return await _service.deletarFavorito(docId);
  }
}
