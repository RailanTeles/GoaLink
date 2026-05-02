import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/core/navbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/services/cache_service.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;
  CacheService get cacheService => CacheService();

  @override
  Widget build(BuildContext context) {
    final Future<UsuarioModel?> usuario = cacheService.buscarPerfilLocal();
    return Scaffold(
      extendBody: true,
      appBar: const Navbar(),
      body: SafeArea(bottom: false, child: navigationShell),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF195E3B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: FutureBuilder(
              future: usuario,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }
                final usuarioModel = snapshot.data;
                return Row(
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String urlImage) {
    final isSelected = navigationShell.currentIndex == index;
    final corAtiva = const Color(0xFF022412);
    final corInativa = Colors.white;
    final corAtual = isSelected ? corAtiva : corInativa;

    return GestureDetector(
      onTap: () => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
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
