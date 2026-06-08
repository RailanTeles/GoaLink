import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/core/navbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goalink/providers/auth_provider.dart';
import 'package:goalink/providers/notification_helper.dart';
import 'package:provider/provider.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final usuario = context.read<AuthProvider>().usuario;
      if (usuario != null) {
        NotificationHelper().inicializarNotificacoes(
          currentUid: usuario.id,
          tokenSalvo: usuario.fcmToken,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final usuarioModel = authProvider.usuario;

    return Scaffold(
      extendBody: true,
      appBar: widget.navigationShell.currentIndex == 4
          ? null
          : Navbar(tipoUsuario: usuarioModel?.tipo),
      body: SafeArea(bottom: false, child: widget.navigationShell),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF195E3B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, "assets/images/icons/home.svg"),
                _buildNavItem(1, "assets/images/icons/search.svg"),
                if (usuarioModel?.tipo == "jogador") ...[
                  _buildNavItem(2, "assets/images/icons/tips.svg"),
                ] else ...[
                  _buildNavItem(5, "assets/images/icons/favorites.svg"),
                ],
                _buildNavItem(3, "assets/images/icons/chat_off.svg"),
                _buildNavItem(4, "assets/images/icons/profile.svg"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String urlImage) {
    final isSelected = widget.navigationShell.currentIndex == index;
    final corAtiva = const Color(0xFF022412);
    final corInativa = Colors.white;
    final corAtual = isSelected ? corAtiva : corInativa;
    return GestureDetector(
      onTap: () => widget.navigationShell.goBranch(
        index,
        initialLocation: index == widget.navigationShell.currentIndex,
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.transparent,
        child: SvgPicture.asset(
          urlImage,
          height: 30,
          width: 30,
          colorFilter: ColorFilter.mode(corAtual, BlendMode.srcIn),
        ),
      ),
    );
  }
}
