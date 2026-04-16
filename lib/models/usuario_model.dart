class UsuarioModel {
  final String id;
  final String tipo;
  final String email;
  final String nome;
  final String? descricao;
  final String? fotoUrl;
  final DateTime criadoEm;
  final DateTime? dataNascimento;
  final double? altura;
  final double? peso;
  final String? posicao;
  final String? cidade;
  final String? pernaPreferida;
  final Map<String, dynamic>? redesSociais;
  final String? clubeRepresentante;
  final String? jogadoresProcurados;

  UsuarioModel({
    required this.id,
    required this.tipo,
    required this.email,
    required this.nome,
    required this.criadoEm,
    this.descricao,
    this.fotoUrl,
    this.dataNascimento,
    this.altura,
    this.peso,
    this.posicao,
    this.cidade,
    this.pernaPreferida,
    this.redesSociais,
    this.clubeRepresentante,
    this.jogadoresProcurados,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] ?? '',
      tipo: json['tipo'] ?? '',
      email: json['email'] ?? '',
      nome: json['nome'] ?? '',
      criadoEm: DateTime.parse(json['criado_em']),
      dataNascimento: json['data_nascimento'] != null
          ? DateTime.parse(json['data_nascimento'])
          : null,
      altura: json['altura']?.toDouble(),
      peso: json['peso']?.toDouble(),
      posicao: json['posicao'],
      cidade: json['cidade'],
      pernaPreferida: json['perna_preferida'],
      descricao: json['descricao'],
      fotoUrl: json['foto_url'],
      redesSociais: json['redes_sociais'],
      clubeRepresentante: json['clube_representante'],
      jogadoresProcurados: json['jogadores_procurados'],
    );
  }

  Map<String, dynamic> toJson() {
    final dados = {
      'id': id,
      'tipo': tipo,
      'email': email,
      'nome': nome,
      'criado_em': criadoEm.toIso8601String(),
      'data_nascimento': dataNascimento?.toIso8601String(),
      'altura': altura,
      'peso': peso,
      'posicao': posicao,
      'cidade': cidade,
      'perna_preferida': pernaPreferida,
      'descricao': descricao,
      'foto_url': fotoUrl,
      'redes_sociais': redesSociais,
      'clube_representante': clubeRepresentante,
      'jogadores_procurados': jogadoresProcurados,
    };

    dados.removeWhere((chave, valor) => valor == null);

    return dados;
  }

  UsuarioModel copyWith({
    String? id,
    String? tipo,
    String? nome,
    String? email,
    DateTime? criadoEm,
    DateTime? dataNascimento,
    double? altura,
    double? peso,
    String? posicao,
    String? cidade,
    String? pernaPreferida,
    String? descricao,
    String? fotoUrl,
    Map<String, dynamic>? redesSociais,
    String? clubeRepresentante,
    String? jogadoresProcurados,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      email: email ?? this.email,
      nome: nome ?? this.nome,
      criadoEm: criadoEm ?? this.criadoEm,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      altura: altura ?? this.altura,
      peso: peso ?? this.peso,
      posicao: posicao ?? this.posicao,
      cidade: cidade ?? this.cidade,
      pernaPreferida: pernaPreferida ?? this.pernaPreferida,
      descricao: descricao ?? this.descricao,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      redesSociais: redesSociais ?? this.redesSociais,
      clubeRepresentante: clubeRepresentante ?? this.clubeRepresentante,
      jogadoresProcurados: jogadoresProcurados ?? this.jogadoresProcurados,
    );
  }
}
