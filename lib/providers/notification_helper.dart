import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class NotificationHelper {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'default',
  );

  Future<void> inicializarNotificacoes({
    required String currentUid,
    String? tokenSalvo,
  }) async {
    try {
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? tokenDoCelular = await _messaging.getToken();

        if (tokenDoCelular != null && tokenDoCelular != tokenSalvo) {
          await _firestore.collection('usuarios').doc(currentUid).update({
            'fcm_token': tokenDoCelular,
          });

          if (kDebugMode) print('Novo FCM Token gravado no banco de dados!');
        } else {
          if (kDebugMode) {
            print('Token atual já é igual ao do banco. Ignorando.');
          }
        }
      } else {
        if (kDebugMode) print('Usuário recusou a permissão de notificações.');
      }
    } catch (e) {
      if (kDebugMode) print('Erro ao configurar notificações push: $e');
    }
  }
}
