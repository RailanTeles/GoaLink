import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/screens/video_posts/posts_view_model.dart';
import 'package:goalink/screens/video_posts/widgets/media_option_button.dart';
import 'package:goalink/screens/video_posts/widgets/post_media_placeholder.dart';
import 'package:goalink/screens/video_posts/widgets/post_media_preview.dart';
import 'package:goalink/screens/video_posts/widgets/posts_app_bar.dart';
import 'package:goalink/screens/video_posts/widgets/posts_bottom_action.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPostsScreenArgs {
  const AddPostsScreenArgs({required this.path, required this.isVideo});

  final String path;
  final bool isVideo;
}

class AddPostsScreen extends StatefulWidget {
  const AddPostsScreen({super.key, this.args});

  final AddPostsScreenArgs? args;

  @override
  State<AddPostsScreen> createState() => _AddPostsScreenState();
}

class _AddPostsScreenState extends State<AddPostsScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _comentarioController = TextEditingController();

  String? _mediaPath;
  bool _isVideo = false;

  bool get _emPreview => _mediaPath != null;

  @override
  void initState() {
    super.initState();
    final args = widget.args;
    if (args != null) {
      _mediaPath = args.path;
      _isVideo = args.isVideo;
    }
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _openMediaPicker() async {
    final result = await showModalBottomSheet<({String path, bool isVideo})>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
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
                  if (!ctx.mounted) return;
                  Navigator.of(ctx).pop(
                    file == null ? null : (path: file.path, isVideo: false),
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
                  if (!ctx.mounted) return;
                  Navigator.of(
                    ctx,
                  ).pop(file == null ? null : (path: file.path, isVideo: true));
                },
              ),
            ],
          ),
        ),
      ),
    );

    if (result == null || !mounted) return;
    setState(() {
      _mediaPath = result.path;
      _isVideo = result.isVideo;
      _comentarioController.clear();
    });
  }

  void _handleBack() {
    if (_emPreview) {
      setState(() => _mediaPath = null);
    } else {
      context.go('/');
    }
  }

  Future<void> _savePost() async {
    if (_mediaPath == null) return;
    final viewModel = context.read<PostsViewModel>();
    try {
      await viewModel.fazerPostagem(
        caminhoArquivo: _mediaPath!,
        descricao: _comentarioController.text.trim().isEmpty
            ? null
            : _comentarioController.text.trim(),
      );
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Postagem feita com sucesso!')),
      );

      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;

      context.go('/');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<PostsViewModel>().isUploading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _emPreview ? _buildPreviewStep(isSaving) : _buildSelectionStep(),
    );
  }

  Widget _buildSelectionStep() {
    return Column(
      children: [
        PostsAppBar(onBack: _handleBack, onAdd: _openMediaPicker),
        const Expanded(child: Center(child: PostMediaPlaceholder(large: true))),
        PostsBottomAction(
          label: 'Selecionar Foto/Video',
          onPressed: _openMediaPicker,
        ),
      ],
    );
  }

  Widget _buildPreviewStep(bool isSaving) {
    return Column(
      children: [
        PostsAppBar(onBack: _handleBack, onAdd: null),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 240,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.2),
                    color: const Color(0xFFD8DEE4),
                  ),
                  child: PostMediaPreview(
                    mediaPath: _mediaPath!,
                    isVideo: _isVideo,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _comentarioController,
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
        PostsBottomAction(
          label: 'Enviar Postagem',
          onPressed: isSaving ? null : _savePost,
          loading: isSaving,
        ),
      ],
    );
  }
}
