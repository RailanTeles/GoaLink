import 'package:flutter/material.dart';

class InformacoesPessoaisWidget extends StatelessWidget {
  const InformacoesPessoaisWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Informações Pessoais',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            
            _buildInfoRow(context, Icons.cake, 'Idade', '24 anos'),
            _buildInfoRow(context, Icons.fitness_center, 'Peso', '124.0 kg'),
            _buildInfoRow(context, Icons.height, 'Altura', '2.24 m'),
            _buildInfoRow(context, Icons.sports_soccer, 'Posição', 'GOL'),
            _buildInfoRow(context, Icons.location_city, 'Cidade', 'Fortaleza'),
            _buildInfoRow(context, Icons.accessibility_new, 'Perna', 'Direita'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}