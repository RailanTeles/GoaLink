import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/screens/profile/widgets/comentarios_section_widget.dart';
import 'package:goalink/screens/profile/widgets/postagem_section_widget.dart';

class PostagemComentarioWidget extends StatefulWidget {
  const PostagemComentarioWidget({super.key, required this.usuario});

  final UsuarioModel usuario;

  @override
  State<PostagemComentarioWidget> createState() =>
      _PostagemComentarioWidgetState();
}

class _PostagemComentarioWidgetState extends State<PostagemComentarioWidget> {
  bool _showPosts = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _ToggleButton(
                label: 'Postagens',
                isActive: _showPosts,
                onTap: () => setState(() => _showPosts = true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ToggleButton(
                label: 'Comentários',
                isActive: !_showPosts,
                onTap: () => setState(() => _showPosts = false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (_showPosts)
          PostagemSectionWidget(usuario: widget.usuario)
        else
          ComentariosSectionWidget(usuario: widget.usuario),
      ],
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1E6B47),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.black : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
