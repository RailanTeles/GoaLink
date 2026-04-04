import 'package:flutter/material.dart';
import 'package:goalink/core/circular_loading.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/screens/profile/widgets/postagem_comentario_widget.dart';
import 'package:goalink/screens/profile/widgets/perfil_header_widget.dart';
import 'package:goalink/screens/profile/widgets/perfil_infos_widget.dart';
import 'package:goalink/services/usuario_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UsuarioModel _usuario = UsuarioModel(
    id: 'jogador_03',
    tipo: 'jogador',
    nome: 'Lucas Andrade',
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
      'instagram': '@lucas.andrade',
      'linkedin': 'lucas-andrade',
      'facebook': 'lucas.andrade',
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                PerfilHeaderWidget(usuario: _usuario),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(14, 18, 14, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PerfilInfosWidget(usuario: _usuario),
                        const SizedBox(height: 24),
                        PostagemComentarioWidget(usuario: _usuario),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 12,
              bottom: 18,
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: const Color(0xFF1E6B47),
                child: const Icon(Icons.send_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
