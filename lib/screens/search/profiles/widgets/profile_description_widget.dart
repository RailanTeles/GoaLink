import 'package:flutter/material.dart';

class ProfileDescriptionWidget extends StatelessWidget {
  final String? descricao;

  const ProfileDescriptionWidget({super.key, this.descricao});

  @override
  Widget build(BuildContext context) {
    if (descricao == null || descricao!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Descrição',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            descricao!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
