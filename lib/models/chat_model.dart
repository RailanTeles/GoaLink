class MensagemModel {
  final String idMensagem;
  final String remetenteId;
  final String texto;
  final bool lida;
  final DateTime criadoEm;

  MensagemModel({
    required this.idMensagem,
    required this.remetenteId,
    required this.texto,
    required this.lida,
    required this.criadoEm,
  });

  factory MensagemModel.fromJson(Map<String, dynamic> json) {
    return MensagemModel(
      idMensagem: json['id_mensagem'] ?? '',
      remetenteId: json['remetente_id'] ?? '',
      texto: json['texto'] ?? '',
      lida: json['lida'] ?? false,
      criadoEm: DateTime.parse(json['criado_em']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_mensagem': idMensagem,
      'remetente_id': remetenteId,
      'texto': texto,
      'lida': lida,
      'criado_em': criadoEm.toIso8601String(),
    };
  }
}

class ChatModel {
  final String idChat;
  final List<String> participantes;
  final String ultimaMensagem;
  final DateTime atualizadoEm;
  final List<MensagemModel> mensagens;

  ChatModel({
    required this.idChat,
    required this.participantes,
    required this.ultimaMensagem,
    required this.atualizadoEm,
    required this.mensagens,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    var listaMensagensFromJson = json['mensagens'] as List? ?? [];
    List<MensagemModel> listaMensagens = listaMensagensFromJson
        .map((msgJson) => MensagemModel.fromJson(msgJson))
        .toList();

    return ChatModel(
      idChat: json['id_chat'] ?? '',
      participantes: List<String>.from(json['participantes'] ?? []),
      ultimaMensagem: json['ultima_mensagem'] ?? '',
      atualizadoEm: DateTime.parse(json['atualizado_em']),
      mensagens: listaMensagens,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_chat': idChat,
      'participantes': participantes,
      'ultima_mensagem': ultimaMensagem,
      'atualizado_em': atualizadoEm.toIso8601String(),
      'mensagens': mensagens.map((msg) => msg.toJson()).toList(),
    };
  }
}
