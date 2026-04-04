import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';

class ComentariosSectionWidget extends StatelessWidget {
  const ComentariosSectionWidget({super.key, required this.usuario});

  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Fazer comentário',
            prefixIcon: Icon(
              Icons.mode_comment_outlined,
              color: Theme.of(context).primaryColor,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: (usuario.fotoPerfil != null &&
                            usuario.fotoPerfil!.isNotEmpty)
                        ? NetworkImage(usuario.fotoPerfil!)
                        : const AssetImage('assets/images/background.png')
                              as ImageProvider,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      usuario.nome,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Perfil muito promissor. Boa leitura de jogo e presença em campo.',
                style: TextStyle(height: 1.35),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
