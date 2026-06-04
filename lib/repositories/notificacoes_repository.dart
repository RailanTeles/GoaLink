import 'package:goalink/models/notificacao_model.dart';
import 'package:goalink/services/notificacao_service.dart';

class NotificacoesRepository {
  final NotificacaoService _notificacaoService;

  NotificacoesRepository(this._notificacaoService);

  Future<List<NotificacaoModel>> obterNotificacoesUsuario(String uid) async {
    final docs = await _notificacaoService.obterNotificacoesUsuario(uid);

    final notificacoes = docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id_notificacao'] = doc.id;

      return NotificacaoModel.fromJson(data);
    }).toList();

    return notificacoes;
  }

  Future<void> marcarNotificacoesComoLidas(List<String> ids) async {
    await _notificacaoService.marcarNotificacoesComoLidas(ids);
  }
}
