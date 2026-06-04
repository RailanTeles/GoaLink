import 'package:flutter/material.dart';
import 'package:goalink/models/notificacao_model.dart';
import 'package:goalink/repositories/notificacoes_repository.dart';

class NotificationsViewModel extends ChangeNotifier {
  final NotificacoesRepository _notificacoesRepository;

  NotificationsViewModel(this._notificacoesRepository);

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _erro;
  String? get erro => _erro;

  List<NotificacaoModel>? _notificacoes;
  List<NotificacaoModel>? get notificacoes => _notificacoes;

  Future<void> carregarNotificacoes(String uid) async {
    try {
      _isLoading = true;
      notifyListeners();

      _notificacoes = await _notificacoesRepository.obterNotificacoesUsuario(
        uid,
      );
    } catch (e) {
      _erro = e.toString().replaceAll('Exception: ', '');
      debugPrint('$_erro');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> marcarComoLidas() async {
    if (notificacoes == null || notificacoes!.isEmpty) return;

    final ids = notificacoes!
        .where((n) => !n.lida)
        .map((n) => n.idNotificacao)
        .toList();

    if (ids.isEmpty) return;

    try {
      await _notificacoesRepository.marcarNotificacoesComoLidas(ids);
    } catch (e) {
      debugPrint('Erro ao marcar notificações como lidas: $e');
    }
  }
}
