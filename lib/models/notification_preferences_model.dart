class NotificationPreferencesModel {
  final bool interesseClubes;
  final bool mensagens;
  final bool atualizacoes;

  const NotificationPreferencesModel({
    required this.interesseClubes,
    required this.mensagens,
    required this.atualizacoes,
  });

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferencesModel(
      interesseClubes: json['interesse_clubes'] ?? false,
      mensagens: json['mensagens'] ?? false,
      atualizacoes: json['atualizacoes'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'interesse_clubes': interesseClubes,
      'mensagens': mensagens,
      'atualizacoes': atualizacoes,
    };
  }
}
