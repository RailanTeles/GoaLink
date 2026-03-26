import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/app_scaffold.dart';
import 'package:goalink/screens/forgot_password/recuperar_senha.dart';
import 'package:goalink/screens/home/home_screen.dart';
import 'package:goalink/screens/login/login_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          ],
        ),
      ],
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/recuperar-senha',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const RecuperarSenha(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
  ],
);
