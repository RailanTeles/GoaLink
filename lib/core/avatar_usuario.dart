import 'package:flutter/material.dart';

class AvatarUsuario extends StatelessWidget {
  final String? urlFoto;
  final double tamanho;

  const AvatarUsuario({super.key, required this.urlFoto, this.tamanho = 40.0});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: tamanho,
        height: tamanho,
        color: Theme.of(context).colorScheme.primary,
        child: (urlFoto == null || urlFoto!.isEmpty)
            ? Icon(Icons.person, color: Colors.white, size: tamanho * 0.5)
            : Image.network(
                urlFoto!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Icon(
                  Icons.person,
                  color: Colors.white,
                  size: tamanho * 0.5,
                ),
              ),
      ),
    );
  }
}
