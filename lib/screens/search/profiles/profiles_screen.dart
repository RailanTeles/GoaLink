import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/services/usuario_service.dart';
import 'package:goalink/screens/search/profiles/widgets/profile_header_widget.dart';
import 'package:goalink/screens/search/profiles/widgets/profile_info_widget.dart';
import 'package:goalink/screens/search/profiles/widgets/profile_description_widget.dart';
import 'package:goalink/screens/search/profiles/widgets/profile_contacts_widget.dart';
import 'package:goalink/screens/search/profiles/widgets/profile_actions_widget.dart';

class ProfilesScreen extends StatefulWidget {
  final String usuarioId;

  const ProfilesScreen({
    super.key,
    required this.usuarioId,
  });

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  final UsuarioService _usuarioService = UsuarioService();
  late Future<UsuarioModel> _futuroUsuario;

  @override
  void initState() {
    super.initState();
    _futuroUsuario = _usuarioService.getJogadorId(widget.usuarioId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UsuarioModel>(
      future: _futuroUsuario,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.green),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Erro'),
              backgroundColor: Colors.green,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  const Text('Erro ao carregar perfil'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Voltar'),
                  ),
                ],
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Perfil'),
              backgroundColor: Colors.green,
            ),
            body: const Center(
              child: Text('Usuário não encontrado'),
            ),
          );
        }

        final usuario = snapshot.data!;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Header com foto
              SliverToBoxAdapter(
                child: ProfileHeaderWidget(usuario: usuario),
              ),
              // Informações
              SliverToBoxAdapter(
                child: ProfileInfoWidget(usuario: usuario),
              ),
              // Descrição
              SliverToBoxAdapter(
                child: ProfileDescriptionWidget(
                  descricao: usuario.descricao,
                ),
              ),
              // Contatos
              SliverToBoxAdapter(
                child: ProfileContactsWidget(
                  contatos: usuario.contatos,
                  redesSociais: usuario.redesSociais,
                ),
              ),
              // Ações
              SliverToBoxAdapter(
                child: ProfileActionsWidget(
                  onUltimoJogoPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidade em desenvolvimento'),
                      ),
                    );
                  },
                  onComentariosPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidade em desenvolvimento'),
                      ),
                    );
                  },
                ),
              ),
              // Espaço no final
              const SliverToBoxAdapter(
                child: SizedBox(height: 60),
              ),
            ],
          ),
        );
      },
    );
  }
}
