import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/app_scaffold.dart';
import 'package:goalink/screens/chat/chat_detail_screen.dart';
import 'package:goalink/screens/chat/chat_screen.dart';
// import 'package:goalink/screens/favorites/favorites_screen.dart';
import 'package:goalink/screens/forgot_password/recuperar_senha.dart';
import 'package:goalink/screens/home/home_screen.dart';
import 'package:goalink/screens/login/login_screen.dart';
import 'package:goalink/screens/notifications/notifications_screen.dart';
import 'package:goalink/screens/profile/profile_screen.dart';
import 'package:goalink/screens/search/search_screen.dart';
import 'package:goalink/screens/settings/settings_screen.dart';
import 'package:goalink/screens/tips/tips_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Index 0: Home
        StatefulShellBranch(
          routes: [GoRoute(path: '/', builder: (c, s) => const HomeScreen())],
        ),
        // Index 1: Search
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/search', builder: (c, s) => const SearchScreen()),
          ],
        ),
        // Index 2: Tips
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/tips', builder: (c, s) => const TipsScreen()),
          ],
        ),
        // Index 3: Chat
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/chat', builder: (c, s) => const ChatScreen()),
          ],
        ),
        // Index 4: Perfil
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/myprofile',
              builder: (c, s) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/chat/conversation/:chatId',
      builder: (context, state) {
        final chatId = state.pathParameters['chatId']!;
        return ChatDetailScreen(chatId: chatId);
      },
    ),
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
