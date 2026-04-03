import 'package:flutter/material.dart';
import 'package:goalink/core/avatar_usuario.dart';
import 'package:goalink/core/video_player_widget.dart';
import 'package:goalink/models/postagem_model.dart';
import 'package:goalink/models/usuario_model.dart';

class PostsModelWidget extends StatelessWidget {
  const PostsModelWidget({
    super.key,
    required this.usuario,
    required this.postagem,
  });
  final UsuarioModel usuario;
  final PostagemModel postagem;

  @override
  Widget build(BuildContext context) {
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
                    child: VideoPlayerWidget(videoUrl: postagem.midiaUrl),
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
  }
}
