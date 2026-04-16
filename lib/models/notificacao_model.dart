class NotificacaoModel {
  final String idNotificacao;
  final String usuarioId;
  final String tipo;
  final String conteudo;
  final bool lida;
  final DateTime criadoEm;
  final String remetenteId;
  final String remetenteNome;
  final String? remetenteFotoUrl;

  NotificacaoModel({
    required this.idNotificacao,
    required this.usuarioId,
    required this.tipo,
    required this.conteudo,
    required this.lida,
    required this.criadoEm,
    required this.remetenteId,
    required this.remetenteNome,
    this.remetenteFotoUrl,
  });

  factory NotificacaoModel.fromJson(Map<String, dynamic> json) {
    return NotificacaoModel(
      idNotificacao: json['id_notificacao'] ?? '',
      usuarioId: json['usuario_id'] ?? '',
      tipo: json['tipo'] ?? '',
      conteudo: json['conteudo'] ?? '',
      lida: json['lida'] ?? false,
      criadoEm: DateTime.parse(json['criado_em']),
      remetenteId: json['remetente_id'] ?? '',
      remetenteNome: json['remetente_nome'] ?? '',
      remetenteFotoUrl: json['remetente_foto_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_notificacao': idNotificacao,
      'usuario_id': usuarioId,
      'tipo': tipo,
      'conteudo': conteudo,
      'lida': lida,
      'criado_em': criadoEm.toIso8601String(),
      'remetente_id': remetenteId,
      'remetente_nome': remetenteNome,
      'remetente_foto_url': remetenteFotoUrl,
    };
  }
}
