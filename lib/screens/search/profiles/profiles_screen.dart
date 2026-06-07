import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/core/circular_loading.dart';
import 'package:goalink/screens/search/profiles/profiles_view_model.dart';
import 'package:goalink/screens/search/profiles/widgets/post_coment_widget.dart';
import 'package:goalink/screens/search/profiles/widgets/profile_header_widget.dart';
import 'package:goalink/screens/search/profiles/widgets/profile_infos_widget.dart';
import 'package:provider/provider.dart';

class ProfilesScreen extends StatefulWidget {
  final String usuarioId;

  const ProfilesScreen({super.key, required this.usuarioId});

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<ProfilesViewModel>();
      _carregarTudo(viewModel);
    });
  }

  Future<void> _carregarTudo(ProfilesViewModel vm) async {
    await vm.carregarDadosInicias(widget.usuarioId);

    if (vm.erro == null && vm.usuario != null) {
      await Future.wait([
        vm.obterPostagens(widget.usuarioId),
        vm.obterComentarios(widget.usuarioId),
      ]);
    }
  }

  void _mostrarSnackBar(BuildContext context, String mensagem, Color cor) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem), backgroundColor: cor));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfilesViewModel>();

    if (viewModel.isLoadingPerfil && viewModel.usuario == null) {
      return const Scaffold(body: CircularLoading());
    }

    if (viewModel.erro != null) {
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
              Text('Erro: ${viewModel.erro}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Voltar'),
              ),
            ],
          ),
        ),
      );
    }

    if (viewModel.usuario == null || viewModel.meuUsuario == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
          backgroundColor: Colors.green,
        ),
        body: const Center(child: Text('Usuário não encontrado')),
      );
    }

    final usuario = viewModel.usuario!;
    final meuUsuario = viewModel.meuUsuario!;

    final mostrarFavorito =
        meuUsuario.tipo != "jogador" &&
        usuario.tipo == "jogador" &&
        meuUsuario.id != usuario.id;
    final podeComentar = meuUsuario.id != usuario.id;

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
              backgroundColor: Colors.white.withAlpha(200),
              foregroundColor: Colors.black,
            ),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        actions: [
          if (mostrarFavorito)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: viewModel.isLoadingFavoritar
                    ? null
                    : () async {
                        await viewModel.toggleFavorito(usuario.id);

                        if (!context.mounted) return;

                        if (viewModel.erroSnackBar != null) {
                          _mostrarSnackBar(
                            context,
                            viewModel.erroSnackBar!,
                            Colors.red,
                          );
                        } else if (viewModel.sucessoSnackBar != null) {
                          _mostrarSnackBar(
                            context,
                            viewModel.sucessoSnackBar!,
                            Colors.green,
                          );
                        }
                      },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withAlpha(200),
                  foregroundColor: Colors.black,
                ),
                icon: viewModel.isLoadingFavoritar
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : Icon(
                        viewModel.isFavorito ? Icons.star : Icons.star_border,
                        color: viewModel.isFavorito
                            ? Colors.amber
                            : Colors.black,
                      ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        onRefresh: () async {
          await viewModel.carregarDadosInicias(widget.usuarioId);
          if (viewModel.erro == null) {
            await Future.wait([
              viewModel.obterPostagens(widget.usuarioId),
              viewModel.obterComentarios(widget.usuarioId),
            ]);
          }
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: ProfileHeaderWidget(usuario: usuario)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              sliver: SliverToBoxAdapter(child: ProfileInfos(usuario: usuario)),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                top: 10,
                right: 10,
                left: 10,
                bottom: 100,
              ),
              sliver: SliverToBoxAdapter(
                child: PostComentWidget(
                  controller: viewModel,
                  usuario: usuario,
                  isLoadingComentar: viewModel.isLoadingComentar,
                  onComment: podeComentar
                      ? (texto) async {
                          await viewModel.fazerComentario(usuario.id, texto);

                          if (!context.mounted) return;

                          if (viewModel.erroSnackBar != null) {
                            _mostrarSnackBar(
                              context,
                              viewModel.erroSnackBar!,
                              Colors.red,
                            );
                          } else if (viewModel.sucessoSnackBar != null) {
                            _mostrarSnackBar(
                              context,
                              viewModel.sucessoSnackBar!,
                              Colors.green,
                            );
                          }
                        }
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: podeComentar
          ? FloatingActionButton(
              onPressed: () {
                final chatId = viewModel.gerarIdDoChat(
                  meuUsuario.id,
                  usuario.id,
                );
                context.push('/chat/conversation/$chatId', extra: usuario);
              },
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white),
            )
          : null,
    );
  }
}
