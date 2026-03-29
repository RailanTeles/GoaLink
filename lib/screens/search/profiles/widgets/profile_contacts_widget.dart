import 'package:flutter/material.dart';

class ProfileContactsWidget extends StatelessWidget {
  final Map<String, dynamic>? contatos;
  final Map<String, dynamic>? redesSociais;

  const ProfileContactsWidget({super.key, this.contatos, this.redesSociais});

  @override
  Widget build(BuildContext context) {
    final temContatos =
        (contatos?.isNotEmpty ?? false) || (redesSociais?.isNotEmpty ?? false);

    if (!temContatos) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Redes Sociais',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (contatos?['instagram'] != null)
                _buildContactButton(
                  icon: Icons.camera_alt_outlined,
                  label: 'Instagram',
                  value: contatos!['instagram'],
                ),
              if (contatos?['whatsapp'] != null)
                _buildContactButton(
                  icon: Icons.chat_bubble_outline,
                  label: 'WhatsApp',
                  value: contatos!['whatsapp'],
                ),
              if (redesSociais?['instagram'] != null)
                _buildContactButton(
                  icon: Icons.camera_alt_outlined,
                  label: 'Instagram',
                  value: redesSociais!['instagram'],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF195E3B), width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF195E3B), size: 20),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF195E3B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
