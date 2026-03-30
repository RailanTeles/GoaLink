import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:goalink/models/notificacao_model.dart';

class NotificacaoService {
  Future<List<NotificacaoModel>> getNotificacoes() async {
    final response = await rootBundle.loadString('assets/mocks/notificacoes.json');
    final List<dynamic> data = json.decode(response);

    return data
        .map((json) => NotificacaoModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
