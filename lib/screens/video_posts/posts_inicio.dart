import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/screens/video_posts/posts_final.dart';
import 'package:goalink/screens/video_posts/widgets/media_option_button.dart';
import 'package:goalink/screens/video_posts/widgets/post_media_placeholder.dart';
import 'package:goalink/screens/video_posts/widgets/posts_app_bar.dart';
import 'package:goalink/screens/video_posts/widgets/posts_bottom_action.dart';
import 'package:image_picker/image_picker.dart';

class PostsInicio extends StatefulWidget {
  const PostsInicio({super.key});

  @override
  State<PostsInicio> createState() => _PostsInicioState();
}

class _PostsInicioState extends State<PostsInicio> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _selectMedia() async {
    final media = await showModalBottomSheet<PostsFinalArgs>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MediaOptionButton(
                  icon: Icons.photo_outlined,
                  label: 'Selecionar foto',
                  onTap: () async {
                    final file = await _picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 90,
                    );
                    if (!context.mounted) return;
                    Navigator.of(context).pop(
                      file == null
                          ? null
                          : PostsFinalArgs(path: file.path, isVideo: false),
                    );
                  },
                ),
                const SizedBox(height: 14),
                MediaOptionButton(
                  icon: Icons.videocam_outlined,
                  label: 'Selecionar vídeo',
                  onTap: () async {
                    final file = await _picker.pickVideo(
                      source: ImageSource.gallery,
                    );
                    if (!context.mounted) return;
                    Navigator.of(context).pop(
                      file == null
                          ? null
                          : PostsFinalArgs(path: file.path, isVideo: true),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (media == null || !mounted) return;
    context.push('/posts/final', extra: media);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          PostsAppBar(
            onBack: () => context.go('/'),
            onAdd: _selectMedia,
          ),
          const Expanded(
            child: Center(
              child: PostMediaPlaceholder(large: true),
            ),
          ),
          PostsBottomAction(
            label: 'Selecionar Foto/Video',
            onPressed: _selectMedia,
          ),
        ],
      ),
    );
  }
}
