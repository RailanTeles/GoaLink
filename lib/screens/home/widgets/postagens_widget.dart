import 'package:flutter/material.dart';
import 'package:goalink/core/avatar_usuario.dart';
import 'package:goalink/core/video_player_widget.dart';
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
      return const SliverToBoxAdapter(child: SizedBox.shrink());
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
            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: SizedBox(
                width: .infinity,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      mainAxisAlignment: .start,
                      children: [
                        AvatarUsuario(urlFoto: usuario.fotoPerfil),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            usuario.nome,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (postagem.midiaUrl.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 450,
                            minHeight: 200,
                          ),
                          child: Container(
                            width: double.infinity,
                            color: Colors.black,
                            child: VideoPlayerWidget(
                              videoUrl: postagem.midiaUrl,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (postagem.descricao != null &&
                        postagem.descricao!.isNotEmpty) ...[
                      Text(
                        postagem.descricao!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
