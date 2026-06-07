import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/core/avatar_usuario.dart';
import 'package:goalink/models/avaliacao_model.dart';

class CommentsSectionWidget extends StatefulWidget {
  const CommentsSectionWidget({
    super.key,
    required this.avaliacoes,
    this.isLoadingAvaliacoes = false,
    this.erroAvaliacoes,
    this.fazerComentario,
    this.isLoadingComentar = false,
  });

  final List<AvaliacaoModel> avaliacoes;
  final bool isLoadingAvaliacoes;
  final String? erroAvaliacoes;
  final Future<void> Function(String)? fazerComentario;
  final bool isLoadingComentar;

  @override
  State<CommentsSectionWidget> createState() => _CommentsSectionWidgetState();
}

class _CommentsSectionWidgetState extends State<CommentsSectionWidget> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _enviarComentario() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    FocusScope.of(context).unfocus();
    await widget.fazerComentario!(texto);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoadingAvaliacoes) {
      return const CircularProgressIndicator();
    }

    if (widget.erroAvaliacoes != null) {
      return Center(
        child: Text(
          widget.erroAvaliacoes!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.fazerComentario != null)
          TextField(
            controller: _controller,
            maxLength: 300,
            enabled: !widget.isLoadingComentar,
            onSubmitted: (_) => _enviarComentario(),
            decoration: InputDecoration(
              hintText: 'Fazer comentário',
              prefixIcon: Icon(
                Icons.mode_comment_outlined,
                color: Theme.of(context).primaryColor,
              ),
              suffixIcon: widget.isLoadingComentar
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.send, color: Colors.grey),
                      onPressed: _enviarComentario,
                    ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        const SizedBox(height: 12),

        if (widget.avaliacoes.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 30.0),
            child: Center(
              child: Text(
                "Esse usuário não tem nenhuma avaliação ainda.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.avaliacoes.length,
            itemBuilder: (context, index) {
              return CommentWidget(comentario: widget.avaliacoes[index]);
            },
          ),
      ],
    );
  }
}

class CommentWidget extends StatelessWidget {
  const CommentWidget({super.key, required this.comentario});
  final AvaliacaoModel comentario;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push("/search/${comentario.autorId}");
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AvatarUsuario(urlFoto: comentario.autorFotoUrl, tamanho: 36),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    comentario.autorEmail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  _formatarData(comentario.criadoEm),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              comentario.texto,
              style: const TextStyle(height: 1.4, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  String _formatarData(DateTime data) {
    final agora = DateTime.now();
    final diff = agora.difference(data);
    if (diff.inMinutes < 1) return 'agora';
    if (diff.inHours < 1) return '${diff.inMinutes}min';
    if (diff.inDays < 1) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${data.day}/${data.month}/${data.year}';
  }
}
