import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UsuarioModel usuario;

  const ProfileHeaderWidget({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (usuario.fotoPerfil != null && usuario.fotoPerfil!.isNotEmpty)
          ? () => _mostrarFotoTelaCheia(context)
          : null,
      child: Stack(
        children: [
          Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey.shade300),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:
                  (usuario.fotoPerfil != null && usuario.fotoPerfil!.isNotEmpty)
                  ? Image.network(
                      usuario.fotoPerfil!,
                      width: double.infinity,
                      height: 280,
                      fit: BoxFit.cover,
                      alignment: .topCenter,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.person,
                        size: double.infinity,
                        color: Colors.grey,
                      ),
                    )
                  : FittedBox(
                      fit: BoxFit.contain,
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
            ),
          ),
          Container(
            height: 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  usuario.nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (usuario.dataNascimento != null)
                      _buildInfoChip(
                        '${_calcularIdade(usuario.dataNascimento!)} anos',
                      ),
                    const SizedBox(width: 8),
                    if (usuario.peso != null)
                      _buildInfoChip('${usuario.peso?.toStringAsFixed(1)} kg'),
                    const SizedBox(width: 8),
                    if (usuario.altura != null)
                      _buildInfoChip('${usuario.altura?.toStringAsFixed(1)} m'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calcularIdade(DateTime dataNascimento) {
    final hoje = DateTime.now();
    int idade = hoje.year - dataNascimento.year;
    if (hoje.month < dataNascimento.month ||
        (hoje.month == dataNascimento.month && hoje.day < dataNascimento.day)) {
      idade--;
    }
    return idade;
  }

  Widget _buildInfoChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF195E3B).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _mostrarFotoTelaCheia(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(usuario.fotoPerfil!, fit: BoxFit.contain),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                  ),
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
