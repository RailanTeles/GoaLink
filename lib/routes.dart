import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/app_scaffold.dart';
import 'package:goalink/screens/chat/chat_detail_screen.dart';
import 'package:goalink/screens/chat/chat_screen.dart';
import 'package:goalink/screens/favorites/favorites_screen.dart';
import 'package:goalink/screens/forgot_password/recuperar_senha.dart';
import 'package:goalink/screens/home/home_screen.dart';
import 'package:goalink/screens/login/login_screen.dart';
import 'package:goalink/screens/notifications/notifications_screen.dart';
import 'package:goalink/screens/profile/profile_screen.dart';
import 'package:goalink/screens/search/profiles/profiles_screen.dart';
import 'package:goalink/screens/register/funcao_screen.dart';
import 'package:goalink/screens/register/clube/register_clube_final_screen.dart';
import 'package:goalink/screens/register/clube/register_clube_screen.dart';
import 'package:goalink/screens/register/jogador/register_jogador_final_screen.dart';
import 'package:goalink/screens/register/jogador/register_jogador_segundo_screen.dart';
import 'package:goalink/screens/register/jogador/register_jogador_screen.dart';
import 'package:goalink/screens/register/olheiro/register_olheiro_final_screen.dart';
import 'package:goalink/screens/register/olheiro/register_olheiro_screen.dart';
import 'package:goalink/screens/search/search_screen.dart';
import 'package:goalink/screens/settings/settings_screen.dart';
import 'package:goalink/screens/tips/tips_screen.dart';
import 'package:goalink/screens/tips/tip_detail_screen.dart';
import 'package:goalink/models/dica_treino_model.dart';
import 'package:goalink/screens/video_posts/posts_final.dart';
import 'package:goalink/screens/video_posts/posts_inicio.dart';

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
            GoRoute(
              path: '/tips',
              builder: (c, s) => const TipsScreen(),
              routes: [
                GoRoute(
                  path: 'detalhe',
                  builder: (c, s) {
                    final dica = s.extra as DicaTreinoModel;
                    return TipDetailScreen(dica: dica);
                  },
                ),
              ],
            ),
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
        //Index 5: favorites
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              builder: (c, s) => const FavoritesScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/posts/inicio',
      builder: (context, state) => const PostsInicio(),
    ),
    GoRoute(
      path: '/posts/final',
      builder: (context, state) {
        final extra = state.extra as PostsFinalArgs;
        return PostsFinal(
          mediaPath: extra.path,
          isVideo: extra.isVideo,
          initialPost: extra.initialPost,
        );
      },
    ),
    GoRoute(
      path: '/cadastro',
      builder: (context, state) => const RegisterJogadorScreen(),
    ),
    GoRoute(
      path: '/cadastro/jogador-2',
      builder: (context, state) => const RegisterJogadorSegundoScreen(),
    ),
    GoRoute(
      path: '/cadastro/jogador-3',
      builder: (context, state) => const RegisterJogadorFinalScreen(),
    ),
    GoRoute(
      path: '/cadastro/olheiro',
      builder: (context, state) => const RegisterOlheiroScreen(),
    ),
    GoRoute(
      path: '/cadastro/olheiro-final',
      builder: (context, state) => const RegisterOlheiroFinalScreen(),
    ),
    GoRoute(
      path: '/cadastro/clube',
      builder: (context, state) => const RegisterClubeScreen(),
    ),
    GoRoute(
      path: '/cadastro/clube-final',
      builder: (context, state) => const RegisterClubeFinalScreen(),
    ),
    GoRoute(
      path: '/cadastro/funcao',
      builder: (context, state) => const FuncaoScreen(),
    ),
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
    // Rota para perfil de outros usuários
    GoRoute(
      path: '/search/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProfilesScreen(usuarioId: id);
      },
    ),
  ],
);
