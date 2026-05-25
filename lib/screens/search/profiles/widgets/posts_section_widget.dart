import 'package:flutter/material.dart';
import 'package:goalink/core/circular_loading.dart';
import 'package:goalink/core/posts_model_widget.dart';
import 'package:goalink/models/postagem_model.dart';

class PostsSectionWidget extends StatefulWidget {
  const PostsSectionWidget({
    super.key,
    required this.listaPosts,
    required this.myProfile,
    this.isLoading = false,
    this.erroPostagens,
  });
  final List<PostagemModel> listaPosts;
  final bool myProfile;
  final bool isLoading;
  final String? erroPostagens;

  @override
  State<PostsSectionWidget> createState() => _PostsSectionWidgetState();
}

class _PostsSectionWidgetState extends State<PostsSectionWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: CircularLoading(),
      );
    }

    if (widget.erroPostagens != null) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            widget.erroPostagens!,
            textAlign: .center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: .bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );
    }

    if (widget.listaPosts.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            "Nenhuma postagem foi encontrada :(",
            textAlign: .center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: .bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.listaPosts.length,
      itemBuilder: (context, index) {
        final post = widget.listaPosts[index];
        return PostsModelWidget(postagem: post, isMyProfile: widget.myProfile);
      },
    );
  }
}
