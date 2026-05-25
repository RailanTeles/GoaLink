import 'package:flutter/material.dart';
import 'package:goalink/core/circular_loading.dart';
import 'package:goalink/core/posts_model_widget.dart';
import 'package:goalink/models/postagem_model.dart';

class PostsSectionWidget extends StatelessWidget {
  const PostsSectionWidget({
    super.key,
    required this.listaPosts,
    this.isLoading = false,
    this.erroPostagens,
    this.onDelete,
  });

  final List<PostagemModel> listaPosts;
  final bool isLoading;
  final String? erroPostagens;
  final Future<void> Function(PostagemModel)? onDelete;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CircularLoading();
    }

    if (erroPostagens != null) {
      return Center(
        child: Text(
          erroPostagens!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    if (listaPosts.isEmpty) {
      return Center(
        child: Text(
          "Nenhuma postagem foi encontrada :(",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: listaPosts.length,
      itemBuilder: (context, index) {
        final post = listaPosts[index];
        return PostsModelWidget(
          postagem: post,
          onDelete: onDelete != null ? () => onDelete!(post) : null,
        );
      },
    );
  }
}
