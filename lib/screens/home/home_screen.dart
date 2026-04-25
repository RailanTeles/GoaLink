import 'package:flutter/material.dart';
import 'package:goalink/core/circular_loading.dart';
import 'package:goalink/screens/home/home_view_model.dart';
import 'package:goalink/screens/home/widgets/novos_jogadores_widget.dart';
import 'package:goalink/screens/home/widgets/postagens_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _carregarDadosIniciais();
    _scrollController.addListener(_monitorarScroll);
  }

  void _monitorarScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<HomeViewModel>().carregarMaisPosts();
    }
  }

  Future<void> _carregarDadosIniciais() async {
    await context.read<HomeViewModel>().carregarDadosIniciais();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    if (vm.isLoading && vm.postagens.isEmpty) {
      return const CircularLoading();
    }

    // Caso haja um erro
    if (vm.erro != null && vm.postagens.isEmpty) {
      return RefreshIndicator(
        onRefresh: _carregarDadosIniciais,
        child: Center(
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9.0),
                  child: Text(
                    vm.erro!,
                    textAlign: .center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _carregarDadosIniciais,
        color: Theme.of(context).colorScheme.secondary,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Novos jogadores
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: NovosJogadoresWidget(listaJogadores: vm.jogadoresNovos),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            // Postagens
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: PostagensWidget(
                listaPostagens: vm.postagens,
                isCarregandoMais: vm.isCarregandoMais,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
