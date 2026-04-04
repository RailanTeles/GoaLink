import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:goalink/screens/video_posts/posts_final.dart';

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
                _MediaOptionButton(
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
                _MediaOptionButton(
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
                    onPressed: () => Navigator.of(context).maybePop(),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(76, 76),
                    ),
                    iconSize: 74,
                    icon: const Icon(Icons.arrow_left_rounded),
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: _selectMedia,
                      padding: EdgeInsets.zero,
                      iconSize: 26,
                      color: green,
                      icon: const Icon(Icons.add_rounded),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 178,
                  height: 178,
                  decoration: BoxDecoration(
                    border: Border.all(color: green, width: 3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 86,
                      color: green,
                    ),
                  ),
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
                      onPressed: _selectMedia,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9D9D9),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: const Text(
                        'Selecionar Foto/Video',
                        style: TextStyle(
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
}

class _MediaOptionButton extends StatelessWidget {
  const _MediaOptionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: const Color(0xFF1E6B47)),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9D9D9),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
