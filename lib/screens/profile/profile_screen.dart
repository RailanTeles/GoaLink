import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/core/circular_loading.dart';
import 'package:goalink/screens/profile/profile_view_model.dart';
import 'package:goalink/screens/search/profiles/widgets/post_coment_widget.dart';
import 'package:goalink/screens/search/profiles/widgets/profile_header_widget.dart';
import 'package:goalink/screens/search/profiles/widgets/profile_infos_widget.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarDadosIniciais();
      context.read<ProfileViewModel>().addListener(_onViewModelChange);
    });
  }

  void _onViewModelChange() {
    final vm = context.read<ProfileViewModel>();
    if (vm.erroDeletarPostagem != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.erroDeletarPostagem!),
          backgroundColor: Colors.red,
        ),
      );
    }
    if (vm.deletouComSucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Postagem deletada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    context.read<ProfileViewModel>().removeListener(_onViewModelChange);
    super.dispose();
  }

  void _carregarDadosIniciais() async {
    await context.read<ProfileViewModel>().carregarDadosIniciais();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    // Loading
    if (vm.isLoadingPerfil) {
      return const Scaffold(body: CircularLoading());
    }

    // Erro
    if (vm.erro != null && vm.usuario == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ops!'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Colors.white,
        ),
        body: RefreshIndicator(
          onRefresh: () async => _carregarDadosIniciais(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_off_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 64,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        vm.erro!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final usuario = vm.usuario!;

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
      body: RefreshIndicator(
        onRefresh: () async => vm.carregarDadosIniciais(),
        color: Theme.of(context).colorScheme.secondary,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: ProfileHeaderWidget(usuario: usuario)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
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
                  controller: vm,
                  onDelete: vm.deletarPostagem,
                  usuario: usuario,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
