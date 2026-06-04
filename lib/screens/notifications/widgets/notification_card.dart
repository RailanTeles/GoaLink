import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/core/avatar_usuario.dart';
import 'package:goalink/models/notificacao_model.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.notification});
  final NotificacaoModel notification;

  void _onTap(BuildContext context) {
    if (notification.tipo == 'atualizacoes' ||
        notification.tipo == 'interesseClubes') {
      context.push("/search/${notification.remetenteId}");
    } else if (notification.tipo == 'mensagens') {
      context.push('/chat/conversation/${notification.remetenteId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final horaFormatada =
        "${notification.criadoEm.hour.toString().padLeft(2, '0')}:${notification.criadoEm.minute.toString().padLeft(2, '0')}";
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: notification.lida
              ? const Color(0xFFE8ECE9)
              : const Color(0xFF7FA28C),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AvatarUsuario(urlFoto: notification.remetenteFotoUrl, tamanho: 64),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    notification.remetenteNome ?? 'Usuário',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.conteudo,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withValues(alpha: 0.8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Lado direito: Ícone (topo) e Hora (base)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!notification.lida)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: Icon(
                      Icons.notifications_active,
                      color: Colors.black,
                      size: 22,
                    ),
                  )
                else
                  const SizedBox(
                    height: 34,
                  ), // Mantém o alinhamento quando não há ícone

                Text(
                  horaFormatada,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
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
