class MensagemModel {
  final String idMensagem;
  final String remetenteId;
  final String texto;
  final DateTime criadoEm;

  MensagemModel({
    required this.idMensagem,
    required this.remetenteId,
    required this.texto,
    required this.criadoEm,
  });

  factory MensagemModel.fromJson(Map<String, dynamic> json) {
    return MensagemModel(
      idMensagem: json['id_mensagem'] ?? '',
      remetenteId: json['remetente_id'] ?? '',
      texto: json['texto'] ?? '',
      criadoEm: DateTime.parse(json['criado_em']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_mensagem': idMensagem,
      'remetente_id': remetenteId,
      'texto': texto,
      'criado_em': criadoEm.toIso8601String(),
    };
  }

  MensagemModel copyWith({
    String? idMensagem,
    String? remetenteId,
    String? texto,
    DateTime? criadoEm,
  }) {
    return MensagemModel(
      idMensagem: idMensagem ?? this.idMensagem,
      remetenteId: remetenteId ?? this.remetenteId,
      texto: texto ?? this.texto,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }
}
