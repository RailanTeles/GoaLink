import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/core/avatar_usuario.dart';
import 'package:goalink/core/video_player_widget.dart';
import 'package:goalink/models/postagem_model.dart';

class PostsModelWidget extends StatelessWidget {
  const PostsModelWidget({super.key, required this.postagem, this.onDelete});
  final PostagemModel postagem;
  final VoidCallback? onDelete;

  // Popup mostrando as opções
  void _mostrarOpcoes(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text(
                'Deletar postagem',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmarDelecao(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancelar'),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmarDelecao(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Deletar postagem'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tem certeza que deseja deletar esta postagem?'),
              const SizedBox(height: 16),
              if (postagem.midiaUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: postagem.tipoMidia == 'video'
                      ? AspectRatio(
                          aspectRatio: 4 / 5,
                          child: VideoPlayerWidget(videoUrl: postagem.midiaUrl),
                        )
                      : AspectRatio(
                          aspectRatio: 4 / 5,
                          child: Image.network(
                            postagem.midiaUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const ColoredBox(
                              color: Colors.black12,
                              child: Center(child: Icon(Icons.broken_image)),
                            ),
                          ),
                        ),
                ),
              // Preview da descrição
              if (postagem.descricao != null &&
                  postagem.descricao!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  postagem.descricao!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(dialogContext);
              onDelete?.call();
            },
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
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
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _mostrarOpcoes(context),
                  ),
              ],
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
