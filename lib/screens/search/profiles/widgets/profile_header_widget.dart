import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UsuarioModel usuario;

  const ProfileHeaderWidget({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Imagem de fundo
        Container(
          height: 280,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(usuario.fotoPerfil ?? ''),
              fit: BoxFit.cover,
              onError: (exception, stackTrace) {},
            ),
          ),
        ),
        // Overlay com gradiente
        Container(
          height: 280,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
        ),
        // Botão de voltar
        Positioned(
          top: 40,
          left: 20,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
        ),
        // Informações do usuário (no rodapé da imagem)
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
                ],
              ),
            ],
          ),
        ),
      ],
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
        color: const Color(0xFF195E3B).withOpacity(0.8),
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
}
