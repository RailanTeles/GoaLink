class MensagemModel {
  final String idMensagem;
  final String remetenteId;
  final String texto;
  final DateTime criadoEm;
  final bool lida;

  MensagemModel({
    required this.idMensagem,
    required this.remetenteId,
    required this.texto,
    required this.criadoEm,
    required this.lida,
  });

  factory MensagemModel.fromJson(Map<String, dynamic> json) {
    return MensagemModel(
      idMensagem: json['id_mensagem'] ?? '',
      remetenteId: json['remetente_id'] ?? '',
      texto: json['texto'] ?? '',
      criadoEm: json['criado_em'] != null
          ? (json['criado_em'] is String
                ? DateTime.parse(json['criado_em'])
                : (json['criado_em'] as dynamic).toDate())
          : DateTime.now(),
      lida: json['lida'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'remetente_id': remetenteId,
      'texto': texto,
      'criado_em': criadoEm.toIso8601String(),
      'lida': lida,
    };
  }

  MensagemModel copyWith({
    String? idMensagem,
    String? remetenteId,
    String? texto,
    DateTime? criadoEm,
    bool? lida,
  }) {
    return MensagemModel(
      idMensagem: idMensagem ?? this.idMensagem,
      remetenteId: remetenteId ?? this.remetenteId,
      texto: texto ?? this.texto,
      criadoEm: criadoEm ?? this.criadoEm,
      lida: lida ?? this.lida,
    );
  }
}
