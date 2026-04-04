import 'package:flutter/material.dart';
import 'package:goalink/models/notificacao_model.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.notification});

  final NotificacaoModel notification;

  static const Color _cardColor = Color(0xFFA9C3AB);
  static const Color _textColor = Color(0xFF163322);
  static const Color _accentColor = Color(0xFF11452A);
  static const Color _timeColor = Color(0xFF2A4B38);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nome = notification.nomeRemetente ?? 'Usuário';
    final acao = notification.acao ?? notification.conteudo;
    final avatarUrl = notification.avatarUrl;

    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NotificationAvatar(imageUrl: avatarUrl),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications,
                        size: 14,
                        color: _accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: _textColor,
                        height: 1.35,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: nome,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: ' $acao'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      _formatTime(notification.criadoEm),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _timeColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final localTime = dateTime.toLocal();
    final hour = localTime.hour.toString().padLeft(2, '0');
    final minute = localTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _NotificationAvatar extends StatelessWidget {
  const _NotificationAvatar({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: ClipOval(
        child: ColoredBox(
          color: const Color(0xFFD7E4D7),
          child: SizedBox.expand(
            child: _buildAvatarContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarContent() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return const Icon(Icons.person, color: Color(0xFF11452A), size: 28);
    }

    if (imageUrl!.startsWith('http')) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        errorBuilder: (_, _, _) {
          return const Icon(Icons.person, color: Color(0xFF11452A), size: 28);
        },
      );
    }

    return Image.asset(
      imageUrl!,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      errorBuilder: (_, _, _) {
        return const Icon(Icons.person, color: Color(0xFF11452A), size: 28);
      },
    );
  }
}
