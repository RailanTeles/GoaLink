import 'package:flutter/material.dart';
import 'package:goalink/core/posts_model_widget.dart';
import 'package:goalink/models/postagem_model.dart';

class PostagensWidget extends StatelessWidget {
  const PostagensWidget({
    super.key,
    required this.listaPostagens,
    required this.isCarregandoMais,
  });

  final List<PostagemModel> listaPostagens;
  final bool isCarregandoMais;

  @override
  Widget build(BuildContext context) {
    if (listaPostagens.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            'Nenhuma postagem foi feita ainda :(',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverList.builder(
          itemCount: listaPostagens.length,
          itemBuilder: (context, index) {
            final postagem = listaPostagens[index];
            return PostsModelWidget(postagem: postagem);
          },
        ),
        if (isCarregandoMais)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }
}
