import 'package:flutter/material.dart';
import 'package:goalink/models/dica_treino_model.dart';

class TipsWidget extends StatelessWidget {
  final DicaTreinoModel dica;

  const TipsWidget({super.key, required this.dica});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 94,
            height: 87,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.5),
              child: Container(
                color: color.withValues(alpha: 0.3),
                child: _buildImagem(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    dica.titulo.isNotEmpty ? dica.titulo : '',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dica.descricao.isNotEmpty ? dica.descricao : '',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withValues(alpha: 0.65),
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagem() {
    if (dica.midiaUrl == null || dica.midiaUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    if (dica.midiaUrl!.startsWith('assets/')) {
      return Image.asset(dica.midiaUrl!, fit: BoxFit.cover);
    }

    return Image.network(
      dica.midiaUrl!,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Icon(Icons.sports_soccer, size: 32, color: Colors.white70),
    );
  }
}
