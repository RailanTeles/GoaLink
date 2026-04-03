import 'package:flutter/material.dart';
import 'package:goalink/models/notificacao_model.dart';
import 'package:goalink/screens/notifications/widgets/notification_card.dart';
import 'package:goalink/services/notificacao_service.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const Color _headerColor = Color(0xFF185B38);
  static const Color _screenColor = Color(0xFFF4F7F2);
  static const Color _titleColor = Color(0xFFE8F2EA);
  static final NotificacaoService _notificacaoService = NotificacaoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _screenColor,
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            _NotificationsHeader(
              onBackPressed: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: FutureBuilder<List<NotificacaoModel>>(
                future: _notificacaoService.getNotificacoes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: CircularProgressIndicator(color: _headerColor),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Nao foi possivel carregar as notificacoes.',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  final notifications = snapshot.data ?? [];

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final horizontalPadding = constraints.maxWidth < 360
                          ? 12.0
                          : 18.0;

                      return ListView.builder(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          18,
                          horizontalPadding,
                          24,
                        ),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: NotificationCard(notification: notification),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsHeader extends StatelessWidget {
  const _NotificationsHeader({required this.onBackPressed});

  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        18,
        MediaQuery.paddingOf(context).top + 14,
        18,
        18,
      ),
      decoration: const BoxDecoration(
        color: NotificationsScreen._headerColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notifica\u00e7\u00f5es',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: NotificationsScreen._titleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _HeaderIconButton(
                icon: Icons.chevron_left_rounded,
                onTap: onBackPressed,
              ),
              const Spacer(),
              const _HeaderIconBadge(icon: Icons.notifications_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: const SizedBox(
        width: 42,
        height: 42,
        child: Icon(Icons.chevron_left_rounded, color: Colors.white, size: 34),
      ),
    );
  }
}

class _HeaderIconBadge extends StatelessWidget {
  const _HeaderIconBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFF0E2D1C),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}
