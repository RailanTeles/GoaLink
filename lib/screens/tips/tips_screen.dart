import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/core/circular_loading.dart';
import 'package:goalink/models/dica_treino_model.dart';
import 'package:goalink/screens/tips/tips_view_model.dart';
import 'package:provider/provider.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TipsViewModel>().obterDicas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TipsViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: _buildBodyContent(vm),
    );
  }

  Widget _buildBodyContent(TipsViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularLoading());
    }

    if (vm.error != null) {
      return RefreshIndicator(
        onRefresh: vm.obterDicas,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: Text(
                '${vm.error}',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: vm.obterDicas,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _buildFilterBar(context, vm),
          ),
          Expanded(
            child: vm.dicasFiltradas.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma dica encontrada para este filtro.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 90,
                    ),
                    itemCount: vm.dicasFiltradas.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      final dica = vm.dicasFiltradas[index];
                      return _TipsWidget(
                        dica: dica,
                      ); // Widget construído logo abaixo
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context, TipsViewModel vm) {
    final options = ['Todos', 'Técnico', 'Físico'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.map((option) {
          final selecionado = vm.filtroAtual == option;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(option),
              selected: selecionado,
              onSelected: (_) => vm.alterarFiltro(option),
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: selecionado ? Colors.white : Colors.black87,
                fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TipsWidget extends StatelessWidget {
  final DicaTreinoModel dica;

  const _TipsWidget({required this.dica});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/tips/exercices/${dica.idDica}'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 90,
                height: 90,
                child: dica.midiaUrl != null && dica.midiaUrl!.isNotEmpty
                    ? Image.network(
                        dica.midiaUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            const Icon(Icons.image_not_supported),
                      )
                    : Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.sports_soccer,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    dica.titulo,
                    style: const TextStyle(fontSize: 18, fontWeight: .bold),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dica.descricao,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    maxLines: 3,
                    overflow: .ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      dica.categoria,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
