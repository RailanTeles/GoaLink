import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/models/postagem_model.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/screens/video_posts/posts_final.dart';
import 'package:goalink/services/postagem_service.dart';
import 'package:video_player/video_player.dart';

class PostagemSectionWidget extends StatelessWidget {
  const PostagemSectionWidget({super.key, required this.usuario});

  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    final service = PostagemService();

    return ValueListenableBuilder<List<PostagemModel>>(
      valueListenable: service.postagensNotifier,
      builder: (context, postagens, _) {
        final userPosts = postagens
            .where((post) => post.jogadorId == usuario.id)
            .toList();

        if (userPosts.isEmpty) {
          return const Text(
            'Nenhuma postagem criada ainda.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          );
        }

        return Column(
          children: userPosts
              .map(
                (post) => Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: _ProfilePostCard(usuario: usuario, postagem: post),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _ProfilePostCard extends StatelessWidget {
  const _ProfilePostCard({required this.usuario, required this.postagem});

  final UsuarioModel usuario;
  final PostagemModel postagem;

  @override
  Widget build(BuildContext context) {
    final avatarProvider =
        (usuario.fotoPerfil != null && usuario.fotoPerfil!.isNotEmpty)
        ? NetworkImage(usuario.fotoPerfil!)
        : const AssetImage('assets/images/background.png') as ImageProvider;
    final userHandle = '${usuario.nome.toLowerCase().split(' ').first}@';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 28, backgroundImage: avatarProvider),
            const SizedBox(width: 12),
            Text(
              userHandle,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: 310,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.2),
                  color: const Color(0xFFD8DEE4),
                ),
                child: _ProfileMediaView(
                  mediaUrl: postagem.midiaUrl,
                  isVideo: postagem.isVideo,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    PostagemService().excluirPostagem(postagem.idPostagem);
                  },
                  iconSize: 34,
                  color: const Color(0xFFE32121),
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
                const SizedBox(height: 12),
                Transform.rotate(
                  angle: -0.25,
                  child: IconButton(
                    onPressed: () {
                      context.push(
                        '/posts/final',
                        extra: PostsFinalArgs(
                          path: postagem.midiaUrl,
                          isVideo: postagem.isVideo,
                          initialPost: postagem,
                        ),
                      );
                    },
                    iconSize: 32,
                    color: const Color(0xFF948A2A),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ),
              ],
            ),
          ],
        ),
        if (postagem.descricao != null && postagem.descricao!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            postagem.descricao!,
            style: const TextStyle(
              fontSize: 16,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

class _ProfileMediaView extends StatefulWidget {
  const _ProfileMediaView({required this.mediaUrl, required this.isVideo});

  final String mediaUrl;
  final bool isVideo;

  @override
  State<_ProfileMediaView> createState() => _ProfileMediaViewState();
}

class _ProfileMediaViewState extends State<_ProfileMediaView> {
  VideoPlayerController? _controller;
  Uint8List? _imageBytes;

  bool get _isVideo => widget.isVideo;

  @override
  void initState() {
    super.initState();
    if (_isVideo) {
      final uri = Uri.tryParse(widget.mediaUrl);
      final resolvedUri = uri != null && uri.hasScheme
          ? uri
          : Uri.file(widget.mediaUrl);
      _controller = VideoPlayerController.networkUrl(resolvedUri)
        ..initialize().then((_) {
          if (!mounted) return;
          setState(() {}); 
        });
    } else {
      XFile(widget.mediaUrl).readAsBytes().then((bytes) {
        if (!mounted) return;
        setState(() {
          _imageBytes = bytes;
        });
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isVideo) {
      final controller = _controller;
      if (controller == null || !controller.value.isInitialized) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF1E6B47)),
        );
      }

      return Stack(
        alignment: Alignment.center,
        children: [
          ColoredBox(
            color: Colors.black,
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                controller.value.isPlaying
                    ? controller.pause()
                    : controller.play();
              });
            },
            iconSize: 58,
            color: Colors.white,
            icon: Icon(
              controller.value.isPlaying
                  ? Icons.pause_circle_filled_rounded
                  : Icons.play_circle_fill_rounded,
            ),
          ),
        ],
      );
    }

    if (_imageBytes == null) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF1E6B47)),
      );
    }

    return Image.memory(
      _imageBytes!,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => CustomPaint(
        painter: _PlaceholderPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _PlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = const Color(0xFFD3DAE1);
    final shapePaint = Paint()..color = const Color(0xFFF5F7F9);

    canvas.drawRect(Offset.zero & size, backgroundPaint);
    canvas.drawCircle(
      Offset(size.width * 0.29, size.height * 0.44),
      18,
      shapePaint,
    );

    final path = Path()
      ..moveTo(0, size.height * 0.64)
      ..quadraticBezierTo(
        size.width * 0.08,
        size.height * 0.53,
        size.width * 0.18,
        size.height * 0.60,
      )
      ..quadraticBezierTo(
        size.width * 0.26,
        size.height * 0.67,
        size.width * 0.33,
        size.height * 0.73,
      )
      ..quadraticBezierTo(
        size.width * 0.41,
        size.height * 0.78,
        size.width * 0.49,
        size.height * 0.61,
      )
      ..quadraticBezierTo(
        size.width * 0.66,
        size.height * 0.22,
        size.width * 0.82,
        size.height * 0.34,
      )
      ..quadraticBezierTo(
        size.width * 0.91,
        size.height * 0.42,
        size.width,
        size.height * 0.66,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, shapePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
