import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';

class ProfileInfoWidget extends StatelessWidget {
  final UsuarioModel usuario;

  const ProfileInfoWidget({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // Cidade e Posição
          Row(
            children: [
              Expanded(
                child: _buildInfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Cidade',
                  value: usuario.cidade ?? 'Não informado',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildInfoRow(
                  icon: Icons.sports_soccer_outlined,
                  label: 'Posição',
                  value: usuario.posicao ?? 'Não informado',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Perna Preferida e Altura
          Row(
            children: [
              Expanded(
                child: _buildInfoRow(
                  icon: Icons.directions_run_outlined,
                  label: 'Perna',
                  value: usuario.pernaPreferida ?? 'Não informado',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildInfoRow(
                  icon: Icons.straighten_outlined,
                  label: 'Altura',
                  value: usuario.altura != null
                      ? '${usuario.altura!.toStringAsFixed(2)} m'
                      : 'Não informado',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF195E3B)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
