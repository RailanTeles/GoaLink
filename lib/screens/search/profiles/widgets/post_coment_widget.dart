import 'package:flutter/material.dart';
import 'package:goalink/models/avaliacao_model.dart';
import 'package:goalink/models/postagem_model.dart';
import 'package:goalink/screens/search/profiles/widgets/comments_section_widget.dart';
import 'package:goalink/screens/search/profiles/widgets/posts_section_widget.dart';

class PostComentWidget extends StatefulWidget {
  const PostComentWidget({
    super.key,
    required this.postagens,
    required this.avaliacoes,
    this.isLoadingPostagens = false,
    this.isLoadingAvaliacoes = false,
    this.erroPostagens,
    this.erroAvaliacoes,
  });

  final List<PostagemModel> postagens;
  final List<AvaliacaoModel> avaliacoes;
  final bool isLoadingPostagens;
  final bool isLoadingAvaliacoes;
  final String? erroPostagens;
  final String? erroAvaliacoes;

  @override
  State<PostComentWidget> createState() => _PostComentWidgetState();
}

class _PostComentWidgetState extends State<PostComentWidget> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
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
                              ? const Color(0xFF022412)
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
                              ? const Color(0xFF022412)
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
                        listaPosts: widget.postagens,
                        myProfile: true,
                        isLoading: widget.isLoadingPostagens,
                        erroPostagens: widget.erroPostagens,
                      )
                    : CommentsSectionWidget(
                        avaliacoes: widget.avaliacoes,
                      ), // TODO: Implementar a seção de Comentários corretamente
              ),
            ],
          );
        },
      ),
    );
  }
}
