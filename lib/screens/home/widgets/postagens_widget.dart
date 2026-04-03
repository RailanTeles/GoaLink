import 'package:flutter/material.dart';
import 'package:goalink/core/posts_model_widget.dart';
import 'package:goalink/models/postagem_model.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/services/usuario_service.dart';

class PostagensWidget extends StatefulWidget {
  const PostagensWidget({super.key, required this.listaPostagens});
  final List<PostagemModel> listaPostagens;

  @override
  State<PostagensWidget> createState() => _PostagensWidgetState();
}

class _PostagensWidgetState extends State<PostagensWidget> {
  final UsuarioService _usuarioService = UsuarioService();

  @override
  Widget build(BuildContext context) {
    if (widget.listaPostagens.isEmpty) {
      return const SizedBox.shrink();
    }

    return SliverList.builder(
      itemCount: widget.listaPostagens.length,
      itemBuilder: (context, index) {
        final postagem = widget.listaPostagens[index];
        return FutureBuilder<UsuarioModel?>(
          future: _usuarioService.getJogadorId(postagem.jogadorId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const SizedBox.shrink();
            }
            final usuario = snapshot.data!;
            return PostsModelWidget(postagem: postagem, usuario: usuario);
          },
        );
      },
    );
  }
}
