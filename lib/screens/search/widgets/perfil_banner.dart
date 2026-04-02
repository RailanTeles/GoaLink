import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/core/avatar_usuario.dart';
import 'package:goalink/models/usuario_model.dart';

class PerfilBanner extends StatelessWidget {
  const PerfilBanner({super.key, required this.usuario});
  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 5),
      child: ListTile(
        onTap: () {
          context.push('/search/${usuario.id}');
        },
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        leading: AvatarUsuario(urlFoto: usuario.fotoPerfil, tamanho: 45),
        title: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          children: [
            Text(
              usuario.nome,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: .w600),
            ),
            SizedBox(width: 5),
            Text(
              usuario.tipo,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
