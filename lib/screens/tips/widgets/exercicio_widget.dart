import 'package:flutter/material.dart';
import 'package:goalink/models/exercicio_model.dart';
import 'package:video_player/video_player.dart';

class ExercicioWidget extends StatelessWidget {
  final ExercicioModel exercicio;

  const ExercicioWidget({super.key, required this.exercicio});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 94,
                height: 87,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.5),
                  child: Container(
                    color: color.withValues(alpha: 0.3),
                    child: _buildImagem(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (exercicio.videoUrl != null && exercicio.videoUrl!.isNotEmpty)
                GestureDetector(
                  onTap: () => _abrirVideo(context, exercicio.videoUrl!),
                  child: Container(
                    width: 94,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.play_circle_outline, size: 20),
                        SizedBox(height: 2),
                        Text(
                          'Vídeo\ndemonstrativo',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    exercicio.titulo.isNotEmpty ? exercicio.titulo : '',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  exercicio.descricao.isNotEmpty ? exercicio.descricao : '',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withValues(alpha: 0.65),
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagem() {
    if (exercicio.midiaUrl == null || exercicio.midiaUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    if (exercicio.midiaUrl!.startsWith('assets/')) {
      return Image.asset(exercicio.midiaUrl!, fit: BoxFit.cover);
    }

    return Image.network(
      exercicio.midiaUrl!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Icon(Icons.sports_soccer, size: 32, color: Colors.white70),
    );
  }

  void _abrirVideo(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => _VideoDialog(videoUrl: url),
    );
  }
}

class _VideoDialog extends StatefulWidget {
  final String videoUrl;

  const _VideoDialog({required this.videoUrl});

  @override
  State<_VideoDialog> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<_VideoDialog> {
  late VideoPlayerController _controller;
  bool _erro = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _controller.initialize().then((_) {
      if (mounted) {
        setState(() {});
        _controller.play();
      }
    }).catchError((e) {
      if (mounted) setState(() => _erro = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            if (_erro)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Erro ao carregar vídeo.',
                  style: TextStyle(color: Colors.white),
                ),
              )
            else if (_controller.value.isInitialized)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
