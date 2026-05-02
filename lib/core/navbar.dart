import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/services/cache_service.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({super.key});
  CacheService get cacheService => CacheService();

  @override
  Widget build(BuildContext context) {
    final Future<UsuarioModel?> usuarioFuture = cacheService
        .buscarPerfilLocal();
    return FutureBuilder(
      future: usuarioFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }
        final usuario = snapshot.data;
        return AppBar(
          toolbarHeight: 70,
          centerTitle: true,
          title: Image.asset("assets/images/logo.png", height: 45),
          leading: usuario?.tipo == "jogador"
              ? IconButton(
                  icon: const Icon(Icons.add_box, size: 28),
                  onPressed: () => context.push('/posts/inicio'),
                )
              : SizedBox(),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, size: 28),
              onPressed: () => context.push('/notifications'),
            ),
            const SizedBox(width: 8),
          ],
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class ChatNavbar extends StatelessWidget implements PreferredSizeWidget {
  const ChatNavbar({super.key});

  static const Color _darkGreen = Color(0xFF195E3B);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Image.asset("assets/images/logo.png", height: 44),
      leading: IconButton(
        icon: const Icon(Icons.add_box, size: 28),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, size: 26),
          onPressed: () => context.push('/notifications'),
        ),
        const SizedBox(width: 8),
      ],
      backgroundColor: _darkGreen,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
