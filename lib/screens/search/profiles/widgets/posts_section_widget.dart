import 'package:flutter/material.dart';
import 'package:goalink/core/posts_model_widget.dart';
import 'package:goalink/models/postagem_model.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/services/postagem_service.dart';

class PostsSectionWidget extends StatefulWidget {
  const PostsSectionWidget({super.key, required this.usuario});
  final UsuarioModel usuario;

  @override
  State<PostsSectionWidget> createState() => _PostsSectionWidgetState();
}

class _PostsSectionWidgetState extends State<PostsSectionWidget> {
  final PostagemService postagemService = PostagemService();
  late Future<List<PostagemModel>> _futuroListaPosts;

  @override
  void initState() {
    super.initState();
    _futuroListaPosts = PostagemService().getPostagensByUserID(
      widget.usuario.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostagemModel>>(
      future: _futuroListaPosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
                strokeWidth: 4.0,
              ),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox(
            height: 300,
            child: Center(
              child: Text(
                "Nenhuma postagem feita",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
          );
        }

        final listaPosts = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: listaPosts.length,
          itemBuilder: (context, index) {
            final post = listaPosts[index];
            return PostsModelWidget(postagem: post, usuario: widget.usuario);
          },
        );
      },
    );
  }
}
