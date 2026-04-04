import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:goalink/screens/video_posts/widgets/post_media_placeholder.dart';

class PostMediaPreview extends StatefulWidget {
  const PostMediaPreview({
    super.key,
    required this.mediaPath,
    required this.isVideo,
  });

  final String mediaPath;
  final bool isVideo;

  @override
  State<PostMediaPreview> createState() => _PostMediaPreviewState();
}

class _PostMediaPreviewState extends State<PostMediaPreview> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
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
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isVideo) {
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

    return Image.network(
      widget.mediaPath,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const PostMediaPlaceholder(),
    );
  }
}
