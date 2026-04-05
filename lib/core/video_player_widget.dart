import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  double _aspectRatio = 16 / 9;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    if (_videoPlayerController != null) {
      return;
    }

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    await controller.initialize();

    if (!mounted) {
      await controller.dispose();
      return;
    }

    _videoPlayerController = controller;
    _aspectRatio = controller.value.aspectRatio;

    _chewieController = ChewieController(
      videoPlayerController: controller,
      autoPlay: false,
      looping: true,
      aspectRatio: _aspectRatio,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );

    if (mounted) {
      setState(() {});
    }
  }

  void _disposePlayer() {
    final chewie = _chewieController;
    final controller = _videoPlayerController;
    _chewieController = null;
    _videoPlayerController = null;

    chewie?.dispose();
    controller?.dispose();
  }

  @override
  void dispose() {
    _disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReady =
        _chewieController != null &&
        _chewieController!.videoPlayerController.value.isInitialized;

    if (isReady) {
      _aspectRatio = _chewieController!.videoPlayerController.value.aspectRatio;
    }

    return RepaintBoundary(
      child: AspectRatio(
        aspectRatio: _aspectRatio,
        child: isReady
            ? Chewie(controller: _chewieController!)
            : const ColoredBox(
                color: Colors.black,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Carregando vídeo...'),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
