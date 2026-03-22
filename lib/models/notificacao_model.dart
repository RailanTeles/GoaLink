class NotificacaoModel {
  final String idNotificacao;
  final String usuarioId;
  final String tipo;
  final String conteudo;
  final String linkId;
  final bool lida;
  final DateTime criadoEm;

  NotificacaoModel({
    required this.idNotificacao,
    required this.usuarioId,
    required this.tipo,
    required this.conteudo,
    required this.linkId,
    required this.lida,
    required this.criadoEm,
  });

  factory NotificacaoModel.fromJson(Map<String, dynamic> json) {
    return NotificacaoModel(
      idNotificacao: json['id_notificacao'] ?? '',
      usuarioId: json['usuario_id'] ?? '',
      tipo: json['tipo'] ?? '',
      conteudo: json['conteudo'] ?? '',
      linkId: json['link_id'] ?? '',
      lida: json['lida'] ?? false,
      criadoEm: DateTime.parse(json['criado_em']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_notificacao': idNotificacao,
      'usuario_id': usuarioId,
      'tipo': tipo,
      'conteudo': conteudo,
      'link_id': linkId,
      'lida': lida,
      'criado_em': criadoEm.toIso8601String(),
    };
  }
}
