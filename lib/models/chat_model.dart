class ChatModel {
  final String idChat;
  final List<String> participantes;
  final String ultimaMensagem;
  final DateTime atualizadoEm;
  final Map<String, dynamic> usuarioDados;
  final Map<String, bool> digitando;
  final Map<String, int> mensagensNaoLidas;

  ChatModel({
    required this.idChat,
    required this.participantes,
    required this.ultimaMensagem,
    required this.atualizadoEm,
    required this.usuarioDados,
    required this.digitando,
    required this.mensagensNaoLidas,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      idChat: json['id_chat'] ?? '',
      participantes: List<String>.from(json['participantes'] ?? []),
      ultimaMensagem: json['ultima_mensagem'] ?? '',
      atualizadoEm: json['atualizado_em'] != null
          ? (json['atualizado_em'] is String
                ? DateTime.parse(json['atualizado_em'])
                : (json['atualizado_em'] as dynamic).toDate())
          : DateTime.now(),
      usuarioDados: json['usuario_dados'] ?? {},
      digitando: Map<String, bool>.from(json['digitando'] ?? {}),
      mensagensNaoLidas: Map<String, int>.from(
        json['mensagens_nao_lidas'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participantes': participantes,
      'ultima_mensagem': ultimaMensagem,
      'atualizado_em': atualizadoEm.toIso8601String(),
      'usuario_dados': usuarioDados,
      'digitando': digitando,
      'mensagens_nao_lidas': mensagensNaoLidas,
    };
  }

  ChatModel copyWith({
    String? idChat,
    List<String>? participantes,
    String? ultimaMensagem,
    DateTime? atualizadoEm,
    Map<String, dynamic>? usuarioDados,
    Map<String, bool>? digitando,
    Map<String, int>? mensagensNaoLidas,
  }) {
    return ChatModel(
      idChat: idChat ?? this.idChat,
      participantes: participantes ?? this.participantes,
      ultimaMensagem: ultimaMensagem ?? this.ultimaMensagem,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      usuarioDados: usuarioDados ?? this.usuarioDados,
      digitando: digitando ?? this.digitando,
      mensagensNaoLidas: mensagensNaoLidas ?? this.mensagensNaoLidas,
    );
  }
}
