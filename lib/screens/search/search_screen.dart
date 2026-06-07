import 'package:flutter/material.dart';
import 'package:goalink/screens/search/widgets/filtros_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:goalink/core/circular_loading.dart';
import 'package:goalink/screens/search/search_view_model.dart';
import 'package:goalink/screens/search/widgets/perfil_banner.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _abrirModalFiltros(BuildContext context, SearchViewModel vm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return FiltrosBottomSheet(vm: vm);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewModel>();
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 16,
                  right: 16,
                  bottom: 8,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: vm.aoDigitar,
                  decoration: InputDecoration(
                    hintText: "Pesquisar usuários...",
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                    ),
                    suffixIcon: IconButton(
                      icon: Stack(
                        children: [
                          Icon(
                            Icons.tune,
                            color: Theme.of(context).primaryColor,
                          ),
                          if (vm.filtrosAtuais != null)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      onPressed: () => _abrirModalFiltros(context, vm),
                    ),
                    filled: true,
                    fillColor: Colors.grey.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (vm.isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: CircularLoading(),
              )
            else if (vm.erro != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    '${vm.erro}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else if (vm.usuarios.isEmpty &&
                vm.termoBuscaAtual.isEmpty &&
                vm.filtrosAtuais == null)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    "Escreva ou filtre para pesquisar",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            else if (vm.usuarios.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    "Nenhum perfil encontrado",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            // Exibe a lista
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                sliver: SliverList.builder(
                  itemCount: vm.usuarios.length,
                  itemBuilder: (context, index) {
                    final usuario = vm.usuarios[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PerfilBanner(usuario: usuario),
                    );
                  },
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }
}
