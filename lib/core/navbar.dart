import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Image.asset("assets/images/logo.png", height: 45),
      leading: IconButton(
        icon: const Icon(Icons.add_box, size: 28),
        onPressed: () => context.push('/posts/inicio'),
      ),
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
      title: Image.asset(
        "assets/images/logo.png",
        height: 44,
      ),
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
