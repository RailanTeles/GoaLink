import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/screens/profile/widgets/perfil_header_widget.dart';
import 'package:goalink/screens/profile/widgets/perfil_infos_widget.dart';
import 'package:goalink/screens/profile/widgets/postagem_comentario_widget.dart';
import 'package:goalink/services/postagem_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PostagemService _postagemService = PostagemService();

  final UsuarioModel _usuario = UsuarioModel(
    id: 'jogador_03',
    tipo: 'jogador',
    nome: 'Lian Pedro',
    criadoEm: DateTime(2026, 4, 3),
    dataNascimento: DateTime(2007, 6, 11),
    altura: 1.60,
    peso: 78.5,
    posicao: 'Goleiro',
    cidade: 'Feira de Santana',
    pernaPreferida: 'Direita',
    descricao: 'Adorum jogar uma bolinha, air',
    fotoPerfil:
        'https://i.ibb.co/XrNzzWdR/Whats-App-Image-2026-03-18-at-19-49-19.jpg',
    redesSociais: const {
      'instagram': 'https://www.instagram.com/lian_p17/',
      'linkedin': 'lucas-andrade',
      'facebook': 'lucas.andrade',
    },
  );

  @override
  void initState() {
    super.initState();
    _postagemService.ensureLoaded();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PerfilHeaderWidget(usuario: _usuario),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 18, 14, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PerfilInfosWidget(usuario: _usuario),
                    const SizedBox(height: 24),
                    PostagemComentarioWidget(usuario: _usuario),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
