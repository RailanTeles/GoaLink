class NotificacaoModel {
  final String idNotificacao;
  final String usuarioId;
  final String tipo;
  final String conteudo;
  final String linkId;
  final bool lida;
  final DateTime criadoEm;
  final String? nomeRemetente;
  final String? acao;
  final String? avatarUrl;

  NotificacaoModel({
    required this.idNotificacao,
    required this.usuarioId,
    required this.tipo,
    required this.conteudo,
    required this.linkId,
    required this.lida,
    required this.criadoEm,
    this.nomeRemetente,
    this.acao,
    this.avatarUrl,
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
      nomeRemetente: json['nome_remetente'],
      acao: json['acao'],
      avatarUrl: json['avatar_url'],
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
      'nome_remetente': nomeRemetente,
      'acao': acao,
      'avatar_url': avatarUrl,
    };
  }
}
