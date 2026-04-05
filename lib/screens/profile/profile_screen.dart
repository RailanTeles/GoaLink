import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/core/circular_loading.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/screens/search/profiles/widgets/post_coment_widget.dart';
import 'package:goalink/screens/search/profiles/widgets/profile_header_widget.dart';
import 'package:goalink/screens/search/profiles/widgets/profile_infos_widget.dart';
import 'package:goalink/services/usuario_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UsuarioService _usuarioService = UsuarioService();
  late Future<UsuarioModel> _futuroUsuario;

  @override
  void initState() {
    super.initState();
    _futuroUsuario = _usuarioService.getJogadorId('jogador_01');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UsuarioModel>(
      future: _futuroUsuario,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: CircularLoading());
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Erro'),
              backgroundColor: const Color(0xFF195E3B),
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
                    onPressed: () {
                      setState(() {
                        _futuroUsuario = _usuarioService.getJogadorId(
                          'jogador_01',
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF195E3B),
                    ),
                    child: const Text('Tentar novamente'),
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
              backgroundColor: const Color(0xFF195E3B),
            ),
            body: const Center(child: Text('Usuário não encontrado')),
          );
        }

        final usuario = snapshot.data!;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () => context.push('/settings'),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.8),
                    foregroundColor: Colors.black,
                  ),
                  icon: const Icon(Icons.settings_outlined),
                ),
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: ProfileHeaderWidget(usuario: usuario)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                sliver: SliverToBoxAdapter(
                  child: ProfileInfos(usuario: usuario),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(
                  top: 10,
                  right: 10,
                  left: 10,
                  bottom: 100,
                ),
                sliver: SliverToBoxAdapter(
                  child: PostComentWidget(usuario: usuario),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
