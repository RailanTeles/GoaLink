import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/models/postagem_model.dart';
import 'package:goalink/services/postagem_service.dart';
import 'package:goalink/screens/video_posts/widgets/post_media_preview.dart';
import 'package:goalink/screens/video_posts/widgets/posts_app_bar.dart';
import 'package:goalink/screens/video_posts/widgets/posts_bottom_action.dart';

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
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _captionController.text = widget.initialPost?.descricao ?? '';
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            PostsAppBar(
              onBack: () => context.pop(),
              onAdd: () => context.go('/posts/inicio'),
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
                      child: PostMediaPreview(
                        mediaPath: widget.mediaPath,
                        isVideo: widget.isVideo,
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
            PostsBottomAction(
              label: widget.initialPost == null
                  ? 'Enviar Postagem'
                  : 'Salvar Postagem',
              onPressed: _saving ? null : _savePost,
              loading: _saving,
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
