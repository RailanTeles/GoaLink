import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/core/avatar_usuario.dart';
import 'package:goalink/core/video_player_widget.dart';
import 'package:goalink/models/postagem_model.dart';

class PostsModelWidget extends StatelessWidget {
  const PostsModelWidget({super.key, required this.postagem});
  final PostagemModel postagem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => context.push('/search/${postagem.jogadorId}'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AvatarUsuario(urlFoto: postagem.jogadorFotoUrl),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      postagem.jogadorNome,
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
            ),
            const SizedBox(height: 12),
            if (postagem.midiaUrl.isNotEmpty) _buildMidia(),
            const SizedBox(height: 12),
            if (postagem.descricao != null && postagem.descricao!.isNotEmpty)
              Text(
                postagem.descricao!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMidia() {
    final bool isVideo = postagem.tipoMidia == 'video';

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        color: Colors.black,
        child: isVideo ? _buildVideo() : _buildImagem(),
      ),
    );
  }

  Widget _buildVideo() {
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: VideoPlayerWidget(videoUrl: postagem.midiaUrl),
    );
  }

  Widget _buildImagem() {
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Image.network(
        postagem.midiaUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const ColoredBox(
            color: Colors.black,
            child: Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const ColoredBox(
            color: Colors.black,
            child: Center(
              child: Icon(Icons.broken_image, color: Colors.white54, size: 48),
            ),
          );
        },
      ),
    );
  }
}
