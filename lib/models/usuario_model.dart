class UsuarioModel {
  final String id;
  final String tipo;
  final String nome;
  final DateTime criadoEm;
  final DateTime? dataNascimento;
  final double? altura;
  final double? peso;
  final String? posicao;
  final String? cidade;
  final String? cpf;
  final String? pernaPreferida;
  final String? descricao;
  final String? fotoPerfil;
  final Map<String, dynamic>? redesSociais;
  final String? clubeRepresentante;
  final String? jogadoresProcurados;

  UsuarioModel({
    required this.id,
    required this.tipo,
    required this.nome,
    required this.criadoEm,
    this.dataNascimento,
    this.altura,
    this.peso,
    this.posicao,
    this.cidade,
    this.cpf,
    this.pernaPreferida,
    this.descricao,
    this.fotoPerfil,
    this.redesSociais,
    this.clubeRepresentante,
    this.jogadoresProcurados,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] ?? '',
      tipo: json['tipo'] ?? '',
      nome: json['nome'] ?? '',
      criadoEm: DateTime.parse(json['criado_em']),
      dataNascimento: json['data_nascimento'] != null
          ? DateTime.parse(json['data_nascimento'])
          : null,
      altura: json['altura']?.toDouble(),
      peso: json['peso']?.toDouble(),
      posicao: json['posicao'],
      cidade: json['cidade'],
      cpf: json['cpf'],
      pernaPreferida: json['perna_preferida'],
      descricao: json['descricao'],
      fotoPerfil: json['foto_perfil'],
      redesSociais: json['redes_sociais'],
      clubeRepresentante: json['clube_representante'],
      jogadoresProcurados: json['jogadores_procurados'],
    );
  }

  Map<String, dynamic> toJson() {
    final dados = {
      'id': id,
      'tipo': tipo,
      'nome': nome,
      'criado_em': criadoEm.toIso8601String(),
      'data_nascimento': dataNascimento?.toIso8601String(),
      'altura': altura,
      'peso': peso,
      'posicao': posicao,
      'cidade': cidade,
      'cpf': cpf,
      'perna_preferida': pernaPreferida,
      'descricao': descricao,
      'foto_perfil': fotoPerfil,
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
    DateTime? criadoEm,
    DateTime? dataNascimento,
    double? altura,
    double? peso,
    String? posicao,
    String? cidade,
    String? cpf,
    String? pernaPreferida,
    String? descricao,
    String? fotoPerfil,
    String? videoPerfil,
    Map<String, dynamic>? contatos,
    Map<String, dynamic>? redesSociais,
    String? clubeRepresentante,
    String? jogadoresProcurados,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      nome: nome ?? this.nome,
      criadoEm: criadoEm ?? this.criadoEm,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      altura: altura ?? this.altura,
      peso: peso ?? this.peso,
      posicao: posicao ?? this.posicao,
      cidade: cidade ?? this.cidade,
      cpf: cpf ?? this.cpf,
      pernaPreferida: pernaPreferida ?? this.pernaPreferida,
      descricao: descricao ?? this.descricao,
      fotoPerfil: fotoPerfil ?? this.fotoPerfil,
      redesSociais: redesSociais ?? this.redesSociais,
      clubeRepresentante: clubeRepresentante ?? this.clubeRepresentante,
      jogadoresProcurados: jogadoresProcurados ?? this.jogadoresProcurados,
    );
  }
}
