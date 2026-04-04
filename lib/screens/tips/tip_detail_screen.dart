import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/models/dica_treino_model.dart';
import 'package:goalink/models/exercicio_model.dart';
import 'package:goalink/screens/tips/widgets/exercicio_widget.dart';
import 'package:goalink/services/comunicacao_service.dart';

class TipDetailScreen extends StatefulWidget {
  final DicaTreinoModel dica;

  const TipDetailScreen({super.key, required this.dica});

  @override
  State<TipDetailScreen> createState() => _TipDetailScreenState();
}

class _TipDetailScreenState extends State<TipDetailScreen> {
  final _comService = ComunicacaoService();
  late Future<List<ExercicioModel>> _exerciciosFuture;
  late String _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.dica.categoria;
    _exerciciosFuture = _comService.getExercicios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 75),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.dica.titulo,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 12),
            _buildFilterBar(context),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<ExercicioModel>>(
                future: _exerciciosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar exercícios.'),
                    );
                  }

                  final exercicios = snapshot.data ?? [];
                  final filtrados = _filtrarExercicios(exercicios);

                  if (filtrados.isEmpty) {
                    return const Center(
                      child: Text('Sem exercícios disponíveis.'),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 90),
                    itemCount: filtrados.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) =>
                        ExercicioWidget(exercicio: filtrados[index]),
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
            onPressed: () {
              if (option != widget.dica.categoria) {
                context.pop(option);
              } else {
                setState(() => _selectedFilter = option);
              }
            },
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
            child: Text(option, style: const TextStyle(fontSize: 14)),
          ),
        );
      }).toList(),
    );
  }

  List<ExercicioModel> _filtrarExercicios(List<ExercicioModel> exercicios) {
    if (_selectedFilter == 'Todos') return exercicios;
    return exercicios
        .where((ex) => ex.categoria == _selectedFilter)
        .toList();
  }
}
