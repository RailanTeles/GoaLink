import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';

class PerfilBanner extends StatelessWidget {
  const PerfilBanner({super.key, required this.usuario});
  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(usuario.nome));
  }
}
