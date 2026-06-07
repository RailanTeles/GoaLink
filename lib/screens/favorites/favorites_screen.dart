import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goalink/core/circular_loading.dart';
import 'package:goalink/screens/favorites/widgets/favorite_card_widget.dart';
import 'package:goalink/screens/favorites/favorite_view_model.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarDadosIniciais();
    });
  }

  Future<void> _carregarDadosIniciais() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await context.read<FavoriteViewModel>().obterFavoritos(uid);
  }

  Future<void> _handleRemoverFavorito(String docId) async {
    final vm = context.read<FavoriteViewModel>();
    final messenger = ScaffoldMessenger.of(context);

    await vm.removerFavorito(docId);
    if (vm.erroSnackBar != null) {
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text('Erro ao remover favorito.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FavoriteViewModel>();

    if (vm.isLoading) {
      return const CircularLoading();
    }

    if (vm.erro != null) {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: _carregarDadosIniciais,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      vm.erro!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (vm.favoritos!.isEmpty) {
      return RefreshIndicator(
        onRefresh: _carregarDadosIniciais,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              child: Center(
                child: Text(
                  'Nenhum favorito encontrado.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: RefreshIndicator(
        onRefresh: _carregarDadosIniciais,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 120,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final favorito = vm.favoritos![index];
                  return FavoriteCard(
                    favorito: favorito,
                    isRemovendo: vm.isRemovendo(favorito.id),
                    onRemove: () => _handleRemoverFavorito(favorito.id),
                  );
                }, childCount: vm.favoritos!.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
