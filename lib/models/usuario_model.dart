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
  final String? pernaPreferida;
  final String? descricao;
  final String? fotoPerfil;
  final Map<String, dynamic>? contatos;
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
    this.pernaPreferida,
    this.descricao,
    this.fotoPerfil,
    this.contatos,
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
      pernaPreferida: json['perna_preferida'],
      descricao: json['descricao'],
      fotoPerfil: json['foto_perfil'],
      contatos: json['contatos'],
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
      'perna_preferida': pernaPreferida,
      'descricao': descricao,
      'foto_perfil': fotoPerfil,
      'contatos': contatos,
      'redes_sociais': redesSociais,
      'clube_representante': clubeRepresentante,
      'jogadores_procurados': jogadoresProcurados,
    };

    dados.removeWhere((chave, valor) => valor == null);

    return dados;
  }
}
