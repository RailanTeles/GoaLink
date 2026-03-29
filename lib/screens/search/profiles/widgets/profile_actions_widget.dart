import 'package:flutter/material.dart';

class ProfileActionsWidget extends StatelessWidget {
  final VoidCallback? onUltimoJogoPressed;
  final VoidCallback? onComentariosPressed;

  const ProfileActionsWidget({
    super.key,
    this.onUltimoJogoPressed,
    this.onComentariosPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onUltimoJogoPressed,
              icon: const Icon(Icons.sports_soccer, size: 18),
              label: const Text('Último Jogo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF195E3B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onComentariosPressed,
              icon: const Icon(Icons.comment_outlined, size: 18),
              label: const Text('Comentários'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF195E3B),
                side: const BorderSide(color: Color(0xFF195E3B)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
