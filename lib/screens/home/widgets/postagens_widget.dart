import 'package:flutter/material.dart';
import 'package:goalink/core/posts_model_widget.dart';
import 'package:goalink/models/postagem_model.dart';
import 'package:goalink/models/usuario_model.dart';

class PostagensWidget extends StatelessWidget {
  const PostagensWidget({
    super.key,
    required this.listaPostagens,
    required this.usuariosPorId,
  });

  final List<PostagemModel> listaPostagens;
  final Map<String, UsuarioModel> usuariosPorId;

  @override
  Widget build(BuildContext context) {
    if (listaPostagens.isEmpty) {
      return const SizedBox.shrink();
    }

    return SliverList.builder(
      itemCount: listaPostagens.length,
      itemBuilder: (context, index) {
        final postagem = listaPostagens[index];
        final usuario = usuariosPorId[postagem.jogadorId];

        if (usuario == null) {
          return const SizedBox.shrink();
        }

        return PostsModelWidget(postagem: postagem, usuario: usuario);
      },
    );
  }
}
