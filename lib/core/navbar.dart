import 'package:flutter/material.dart';

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
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, size: 28),
          onPressed: () {},
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
