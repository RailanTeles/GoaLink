import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/models/postagem_model.dart';
import 'package:goalink/services/postagem_service.dart';
import 'package:video_player/video_player.dart';

class PostsFinal extends StatefulWidget {
  const PostsFinal({
    super.key,
    required this.mediaPath,
    required this.isVideo,
    this.initialPost,
  });

  final String mediaPath;
  final bool isVideo;
  final PostagemModel? initialPost;

  @override
  State<PostsFinal> createState() => _PostsFinalState();
}

class _PostsFinalState extends State<PostsFinal> {
  final TextEditingController _captionController = TextEditingController();
  VideoPlayerController? _videoController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _captionController.text = widget.initialPost?.descricao ?? '';
    if (widget.isVideo) {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.mediaPath),
      )
        ..initialize().then((_) {
          if (!mounted) return;
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF1E6B47);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 74,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: const BoxDecoration(
                color: green,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(76, 76),
                    ),
                    iconSize: 74,
                    icon: const Icon(Icons.arrow_left_rounded),
                  ),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () => context.go('/posts/inicio'),
                      padding: EdgeInsets.zero,
                      iconSize: 28,
                      color: green,
                      icon: const Icon(Icons.add_rounded),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 28, 22, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 240,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.2),
                        color: const Color(0xFFD8DEE4),
                      ),
                      child: widget.isVideo
                          ? _buildVideoPreview()
                          : Image.network(
                              widget.mediaPath,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) {
                                return const _PostPlaceholder();
                              },
                            ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _captionController,
                      minLines: 2,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Insira comentário',
                        hintStyle: const TextStyle(
                          color: Color(0xFF787878),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF1E6B47),
                            width: 1.6,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF1E6B47),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 105,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28, bottom: 22),
                  child: SizedBox(
                    width: 240,
                    height: 62,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _savePost,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9D9D9),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: _saving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              widget.initialPost == null
                                  ? 'Enviar Postagem'
                                  : 'Salvar Postagem',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _savePost() async {
    setState(() {
      _saving = true;
    });

    final initialPost = widget.initialPost;
    if (initialPost != null) {
      await PostagemService().atualizarPostagem(
        initialPost.copyWith(
          midiaUrl: widget.mediaPath,
          descricao: _captionController.text.trim(),
        ),
      );
    } else {
      final post = PostagemModel(
        idPostagem: 'post_${DateTime.now().millisecondsSinceEpoch}',
        jogadorId: 'jogador_03',
        midiaUrl: widget.mediaPath,
        descricao: _captionController.text.trim(),
        criadoEm: DateTime.now(),
      );
      await PostagemService().criarPostagem(post);
    }

    if (!mounted) return;
    context.go('/myprofile');
  }

  Widget _buildVideoPreview() {
    final controller = _videoController;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF1E6B47)),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              if (controller.value.isPlaying) {
                controller.pause();
              } else {
                controller.play();
              }
            });
          },
          iconSize: 62,
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
}

class _PostPlaceholder extends StatelessWidget {
  const _PostPlaceholder();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PlaceholderPainter(),
      child: const SizedBox.expand(),
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

class PostsFinalArgs {
  const PostsFinalArgs({
    required this.path,
    required this.isVideo,
    this.initialPost,
  });

  final String path;
  final bool isVideo;
  final PostagemModel? initialPost;
}
