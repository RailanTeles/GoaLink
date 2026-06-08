import 'package:flutter/material.dart';
import 'package:goalink/models/chat_model.dart';

class ChatCard extends StatelessWidget {
  final ChatModel chat;
  final String meuUid;
  final VoidCallback onTap;

  const ChatCard({
    super.key,
    required this.chat,
    required this.meuUid,
    required this.onTap,
  });

  String _formatarData(DateTime data) {
    final agora = DateTime.now();
    final diff = agora.difference(data);
    if (diff.inMinutes < 1) return 'agora';
    if (diff.inHours < 1) return '${diff.inMinutes}min';
    if (diff.inDays < 1) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${data.day}/${data.month}/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    final outroUid = chat.participantes.firstWhere(
      (id) => id != meuUid,
      orElse: () => '',
    );

    final dadosOutroUsuario = chat.usuarioDados[outroUid] ?? {};
    final nome = dadosOutroUsuario['nome'] ?? 'Desconhecido';
    final fotoUrl = dadosOutroUsuario['foto_perfil'];

    final naoLidas = chat.mensagensNaoLidas[meuUid] ?? 0;
    final outroEstaDigitando = chat.digitando[outroUid] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                    image: fotoUrl != null
                        ? DecorationImage(
                            image: NetworkImage(fotoUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: fotoUrl == null
                      ? Center(
                          child: Text(
                            nome.isNotEmpty ? nome[0].toUpperCase() : '?',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nome,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      outroEstaDigitando
                          ? Text(
                              'Digitando...',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.green.shade600,
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          : Text(
                              chat.ultimaMensagem.isEmpty
                                  ? 'Nova conversa'
                                  : chat.ultimaMensagem,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: naoLidas > 0
                                    ? Colors.black87
                                    : Colors.grey.shade600,
                                fontWeight: naoLidas > 0
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatarData(chat.atualizadoEm),
                      style: TextStyle(
                        fontSize: 11,
                        color: naoLidas > 0
                            ? Colors.green.shade600
                            : Colors.grey.shade500,
                        fontWeight: naoLidas > 0
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (naoLidas > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          naoLidas > 99 ? '99+' : naoLidas.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
