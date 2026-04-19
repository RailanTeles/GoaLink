import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFotoPerfil({
    required String uid,
    required String caminhoLocal,
  }) async {
    final ref = _storage.ref().child('$uid/foto.png');

    final uploadTask = await ref.putFile(
      File(caminhoLocal),
      SettableMetadata(contentType: 'image/png'),
    );

    return await uploadTask.ref.getDownloadURL();
  }

  Future<void> deletarFotoPerfil(String uid) async {
    try {
      await _storage.ref().child('$uid/foto.png').delete();
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') rethrow;
    }
  }
}
