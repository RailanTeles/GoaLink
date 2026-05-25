import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFotoPerfil({
    required String uid,
    required String caminhoLocal,
  }) async {
    try {
      final String extensao = p.extension(caminhoLocal);
      final ref = _storage.ref().child('$uid/perfil$extensao');

      final String? mimeType = lookupMimeType(caminhoLocal);

      final uploadTask = await ref.putFile(
        File(caminhoLocal),
        SettableMetadata(contentType: mimeType ?? 'application/octet-stream'),
      );

      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Erro ao enviar foto de perfil: $e');
    }
  }

  Future<String> uploadMidiaPostagem({
    required String idPostagem,
    required String caminhoLocal,
  }) async {
    try {
      final String extensao = p.extension(caminhoLocal);
      final String nomeArquivo = DateTime.now().millisecondsSinceEpoch
          .toString();

      final ref = _storage.ref().child(
        'postagens/$idPostagem/$nomeArquivo$extensao',
      );

      final String? mimeType = lookupMimeType(caminhoLocal);
      final uploadTask = await ref.putFile(
        File(caminhoLocal),
        SettableMetadata(contentType: mimeType ?? 'application/octet-stream'),
      );

      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Erro ao enviar mídia da postagem: $e');
    }
  }

  Future<void> deletarMidia(String urlMidia) async {
    try {
      final ref = _storage.refFromURL(urlMidia);
      await ref.delete();
    } catch (e) {
      throw Exception('Erro ao deletar mídia: $e');
    }
  }
}
