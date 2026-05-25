import 'package:flutter/material.dart';
import 'package:goalink/core/contracts/post_coment_controller.dart';
import 'package:goalink/models/postagem_model.dart';
import 'package:goalink/screens/search/profiles/widgets/comments_section_widget.dart';
import 'package:goalink/screens/search/profiles/widgets/posts_section_widget.dart';

class PostComentWidget extends StatefulWidget {
  const PostComentWidget({super.key, required this.controller, this.onDelete});

  final PostComentController controller;
  final Future<void> Function(PostagemModel)? onDelete;

  @override
  State<PostComentWidget> createState() => _PostComentWidgetState();
}

class _PostComentWidgetState extends State<PostComentWidget> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    return SizedBox(
      width: .maxFinite,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tamanhoBotao = constraints.maxWidth * 0.4;
          return Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              Row(
                mainAxisAlignment: .spaceEvenly,
                children: [
                  SizedBox(
                    width: tamanhoBotao,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        "Postagens",
                        style: TextStyle(
                          color: _selectedIndex == 0
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: tamanhoBotao,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        "Comentários",
                        style: TextStyle(
                          color: _selectedIndex == 1
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 90.0),
                child: _selectedIndex == 0
                    ? PostsSectionWidget(
                        listaPosts: c.postagens,
                        isLoading: c.isLoadingPostagens,
                        erroPostagens: c.erroPostagens,
                        onDelete: widget.onDelete,
                      )
                    : CommentsSectionWidget(
                        avaliacoes: c.avaliacoes,
                      ), // TODO: Implementar a seção de Comentários corretamente
              ),
            ],
          );
        },
      ),
    );
  }
}
