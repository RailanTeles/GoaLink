class ChatModel {
  final String idChat;
  final List<String> participantes;
  final String ultimaMensagem;
  final DateTime atualizadoEm;
  final Map<String, dynamic> usuarioDados;

  ChatModel({
    required this.idChat,
    required this.participantes,
    required this.ultimaMensagem,
    required this.atualizadoEm,
    required this.usuarioDados,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      idChat: json['id_chat'] ?? '',
      participantes: List<String>.from(json['participantes'] ?? []),
      ultimaMensagem: json['ultima_mensagem'] ?? '',
      atualizadoEm: DateTime.parse(json['atualizado_em']),
      usuarioDados: json['usuario_dados'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_chat': idChat,
      'participantes': participantes,
      'ultima_mensagem': ultimaMensagem,
      'atualizado_em': atualizadoEm.toIso8601String(),
      'usuario_dados': usuarioDados,
    };
  }

  ChatModel copyWith({
    String? idChat,
    List<String>? participantes,
    String? ultimaMensagem,
    DateTime? atualizadoEm,
    Map<String, dynamic>? usuarioDados,
  }) {
    return ChatModel(
      idChat: idChat ?? this.idChat,
      participantes: participantes ?? this.participantes,
      ultimaMensagem: ultimaMensagem ?? this.ultimaMensagem,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      usuarioDados: usuarioDados ?? this.usuarioDados,
    );
  }
}
