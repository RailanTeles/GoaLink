import 'package:flutter/material.dart';
import 'package:goalink/core/circular_loading.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/screens/search/profiles/widgets/post_coment_widget.dart';
import 'package:goalink/screens/search/profiles/widgets/profile_header_widget.dart';
import 'package:goalink/screens/search/profiles/widgets/profile_infos_widget.dart';
import 'package:goalink/services/usuario_service.dart';

class ProfilesScreen extends StatefulWidget {
  final String usuarioId;

  const ProfilesScreen({super.key, required this.usuarioId});

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
          return Scaffold(body: CircularLoading());
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
            body: const Center(child: Text('Usuário não encontrado')),
          );
        }

        final usuario = snapshot.data!;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.8),
                  foregroundColor: Colors.black,
                ),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.8),
                    foregroundColor: Colors.black,
                  ),
                  icon: const Icon(Icons.star_border),
                ),
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: ProfileHeaderWidget(usuario: usuario)),
              SliverPadding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                sliver: SliverToBoxAdapter(
                  child: ProfileInfos(usuario: usuario),
                ),
              ),
              SliverPadding(
                padding: EdgeInsetsGeometry.only(
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.send_rounded, color: Colors.white),
          ),
        );
      },
    );
  }
}
