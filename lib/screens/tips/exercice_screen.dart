import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/core/circular_loading.dart';
import 'package:goalink/core/video_player_widget.dart';
import 'package:goalink/screens/tips/exercice_view_model.dart';
import 'package:provider/provider.dart';

class ExerciceScreen extends StatefulWidget {
  final String idDica;
  const ExerciceScreen({super.key, required this.idDica});

  @override
  State<ExerciceScreen> createState() => _ExerciceScreenState();
}

class _ExerciceScreenState extends State<ExerciceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExercicioViewModel>().obterExercicios(widget.idDica);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExercicioViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Exercícios da Dica',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildBodyContent(vm)),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent(ExercicioViewModel vm) {
    if (vm.isLoading) return const Center(child: CircularLoading());

    if (vm.error != null) {
      return Center(
        child: Text('${vm.error}', style: const TextStyle(color: Colors.red)),
      );
    }

    if (vm.exercicios.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum exercício cadastrado.',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
      itemCount: vm.exercicios.length,
      itemBuilder: (context, index) {
        final exercicio = vm.exercicios[index];

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            title: Text(
              exercicio.titulo,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            iconColor: Theme.of(context).colorScheme.primary,
            collapsedIconColor: Colors.grey.shade600,
            shape: const Border(),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (exercicio.videoUrl != null &&
                  exercicio.videoUrl!.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: double.infinity,
                    child: VideoPlayerWidget(videoUrl: exercicio.videoUrl!),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                exercicio.descricao,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        );
      },
    );
  }
}
