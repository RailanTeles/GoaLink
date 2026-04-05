import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/models/dica_treino_model.dart';
import 'package:goalink/screens/tips/widgets/tips_widget.dart';
import 'package:goalink/services/comunicacao_service.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  final _comService = ComunicacaoService();
  late Future<List<DicaTreinoModel>> _dicasFuture;
  String _selectedFilter = 'Todos';

  @override
  void initState() {
    super.initState();
    _dicasFuture = _comService.getDicasTreino();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dicas de Treinamento', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            _buildFilterBar(context),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<DicaTreinoModel>>(
                future: _dicasFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Erro ao carregar dicas.'));
                  }

                  final dicas = snapshot.data ?? [];
                  final filtradas = _filtrarDicas(dicas);

                  if (filtradas.isEmpty) {
                    return const Center(child: Text('Sem dicas disponíveis.'));
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 90),
                    itemCount: filtradas.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      final dica = filtradas[index];
                      return GestureDetector(
                        onTap: () async {
                          final filtroRetornado = await context.push<String>(
                            '/tips/detalhe',
                            extra: dica,
                          );
                          if (filtroRetornado != null) {
                            setState(() => _selectedFilter = filtroRetornado);
                          }
                        },
                        child: TipsWidget(dica: dica),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    final options = ['Todos', 'Técnico', 'Físico'];
    return Row(
      children: options.map((option) {
        final selecionado = _selectedFilter == option;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: OutlinedButton(
            onPressed: () => setState(() => _selectedFilter = option),
            style: OutlinedButton.styleFrom(
              backgroundColor: selecionado
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white,
              foregroundColor: selecionado ? Colors.white : Colors.black87,
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
            child: Text(option, style: const TextStyle(fontSize: 14)),
          ),
        );
      }).toList(),
    );
  }

  List<DicaTreinoModel> _filtrarDicas(List<DicaTreinoModel> dicas) {
    if (_selectedFilter == 'Todos') return dicas;
    return dicas.where((dica) => dica.categoria == _selectedFilter).toList();
  }
}
