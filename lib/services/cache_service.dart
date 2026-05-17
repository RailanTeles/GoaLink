import 'dart:convert';

import 'package:goalink/models/postagem_model.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CacheService {
  static const String _userBoxName = 'userBox';
  static const String _userKey = 'perfil_logado';
  static const String _postagensBoxName = 'postagensBox';
  static const String _postagensKey = 'postagens';

  static Future<void> inicializarCache() async {
    await Hive.initFlutter();
    await Hive.openBox(_userBoxName);
    await Hive.openBox(_postagensBoxName);
  }

  // Caches relacionados ao perfil logado
  Future<void> salvarPerfilLocal(UsuarioModel usuario) async {
    var box = Hive.box(_userBoxName);
    String usuarioString = jsonEncode(usuario.toJson());

    await box.put(_userKey, usuarioString);
  }

  Future<UsuarioModel?> buscarPerfilLocal() async {
    var box = Hive.box(_userBoxName);
    String? usuarioString = box.get(_userKey);

    if (usuarioString != null) {
      Map<String, dynamic> json = jsonDecode(usuarioString);
      return UsuarioModel.fromJson(json);
    }

    return null;
  }

  Future<void> limparCachePerfilLogado() async {
    var box = Hive.box(_userBoxName);
    await box.delete(_userKey);
  }

  // Caches relacionados a postagens
  Future<void> salvarPostagensLocal(List<PostagemModel> postagens) async {
    var box = Hive.box(_postagensBoxName);
    String postagensString = jsonEncode(
      postagens.map((e) => e.toJson()).toList(),
    );
    await box.put(_postagensKey, postagensString);
  }

  Future<List<PostagemModel>> buscarPostagensLocal() async {
    var box = Hive.box(_postagensBoxName);
    String? postagensString = box.get(_postagensKey);

    if (postagensString != null) {
      final List<dynamic> lista = jsonDecode(postagensString);
      return lista
          .map((e) => PostagemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return [];
  }
}
