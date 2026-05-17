import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/repositories/postagem_repository.dart';
import 'package:goalink/screens/home/home_view_model.dart';
import 'package:goalink/screens/login/login_view_model.dart';
import 'package:goalink/screens/video_posts/add_posts_screen.dart';
import 'package:goalink/screens/video_posts/posts_view_model.dart';
import 'package:goalink/services/cache_service.dart';
import 'package:provider/provider.dart';
import 'package:goalink/repositories/usuario_repository.dart';
import 'package:goalink/screens/login/login_screen.dart';
import 'package:goalink/screens/register/funcao_screen.dart';
import 'package:goalink/screens/register/clube/register_clube_screen.dart';
import 'package:goalink/screens/register/clube/register_clube_view_model.dart';
import 'package:goalink/screens/register/jogador/register_jogador_screen.dart';
import 'package:goalink/screens/register/jogador/register_jogador_view_model.dart';
import 'package:goalink/screens/register/olheiro/register_olheiro_screen.dart';
import 'package:goalink/screens/register/olheiro/register_olheiro_view_model.dart';
import 'package:goalink/services/auth_service.dart';
import 'package:goalink/services/storage_service.dart';
import 'package:goalink/services/usuario_service.dart';
import 'package:goalink/app_scaffold.dart';
import 'package:goalink/screens/home/home_screen.dart';
// import 'package:goalink/screens/chat/chat_detail_screen.dart';
// import 'package:goalink/screens/chat/chat_screen.dart';
// import 'package:goalink/screens/favorites/favorites_screen.dart';
// import 'package:goalink/screens/forgot_password/recuperar_senha.dart';
// import 'package:goalink/screens/notifications/notifications_screen.dart';
// import 'package:goalink/screens/profile/profile_screen.dart';
// import 'package:goalink/screens/search/profiles/profiles_screen.dart';
// import 'package:goalink/screens/register/clube/register_clube_final_screen.dart';
// import 'package:goalink/screens/register/jogador/register_jogador_final_screen.dart';
// import 'package:goalink/screens/register/jogador/register_jogador_segundo_screen.dart';
// import 'package:goalink/screens/register/olheiro/register_olheiro_final_screen.dart';
// import 'package:goalink/screens/search/search_screen.dart';
// import 'package:goalink/screens/settings/settings_screen.dart';
// import 'package:goalink/screens/tips/tips_screen.dart';
// import 'package:goalink/screens/tips/tip_detail_screen.dart';
// import 'package:goalink/models/dica_treino_model.dart';
// import 'package:goalink/screens/video_posts/posts_final.dart';
// import 'package:goalink/screens/video_posts/posts_inicio.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final User? usuarioLogado = FirebaseAuth.instance.currentUser;

    if (usuarioLogado == null) {
      return '/login';
    }

    if (state.matchedLocation == '/login') {
      return '/';
    }

    return null;
  },
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Index 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) {
                return ChangeNotifierProvider(
                  create: (_) => HomeViewModel(
                    context.read<PostagemRepository>(),
                    context.read<UsuarioRepository>(),
                  ),
                  child: const HomeScreen(),
                );
              },
            ),
          ],
        ),
        // Index 1: Search
        // StatefulShellBranch(
        //   routes: [
        //     GoRoute(path: '/search', builder: (c, s) => const SearchScreen()),
        //   ],
        // ),
        // // Index 2: Tips
        // StatefulShellBranch(
        //   routes: [
        //     GoRoute(
        //       path: '/tips',
        //       builder: (c, s) => const TipsScreen(),
        //       routes: [
        //         GoRoute(
        //           path: 'detalhe',
        //           builder: (c, s) {
        //             final dica = s.extra as DicaTreinoModel;
        //             return TipDetailScreen(dica: dica);
        //           },
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
        // // Index 3: Chat
        // StatefulShellBranch(
        //   routes: [
        //     GoRoute(path: '/chat', builder: (c, s) => const ChatScreen()),
        //   ],
        // ),
        // // Index 4: Perfil
        // StatefulShellBranch(
        //   routes: [
        //     GoRoute(
        //       path: '/myprofile',
        //       builder: (c, s) => const ProfileScreen(),
        //     ),
        //   ],
        // ),
        // //Index 5: favorites
        // StatefulShellBranch(
        //   routes: [
        //     GoRoute(
        //       path: '/favorites',
        //       builder: (c, s) => const FavoritesScreen(),
        //     ),
        //   ],
        // ),
      ],
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: ChangeNotifierProvider(
            create: (_) => LoginViewModel(context.read<UsuarioRepository>()),
            child: const LoginScreen(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/cadastro/funcao',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const FuncaoScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/cadastro/jogador',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: ChangeNotifierProvider(
            create: (_) => RegisterJogadorViewModel(
              context.read<UsuarioRepository>(),
              StorageService(),
            ),
            child: const RegisterJogadorScreen(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/cadastro/olheiro',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: ChangeNotifierProvider(
            create: (_) => RegisterOlheiroViewModel(
              UsuarioRepository(
                AuthService(),
                UsuarioService(),
                CacheService(),
              ),
              StorageService(),
            ),
            child: const RegisterOlheiroScreen(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/cadastro/clube',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: ChangeNotifierProvider(
            create: (_) => RegisterClubeViewModel(
              context.read<UsuarioRepository>(),
              StorageService(),
            ),
            child: const RegisterClubeScreen(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/addPosts',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: ChangeNotifierProvider(
            create: (_) => PostsViewModel(
              context.read<PostagemRepository>(),
              CacheService(),
            ),
            child: const AddPostsScreen(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    // GoRoute(
    //   path: '/notifications',
    //   builder: (context, state) => const NotificationsScreen(),
    // ),
    // GoRoute(
    //   path: '/settings',
    //   builder: (context, state) => const SettingsScreen(),
    // ),
    // GoRoute(
    //   path: '/chat/conversation/:chatId',
    //   builder: (context, state) {
    //     final chatId = state.pathParameters['chatId']!;
    //     return ChatDetailScreen(chatId: chatId);
    //   },
    // ),
    // GoRoute(
    //   path: '/recuperar-senha',
    //   pageBuilder: (context, state) {
    //     return CustomTransitionPage(
    //       key: state.pageKey,
    //       child: const RecuperarSenha(),
    //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //         return FadeTransition(
    //           opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
    //           child: child,
    //         );
    //       },
    //     );
    //   },
    // ),
    // // Rota para perfil de outros usuários
    // GoRoute(
    //   path: '/search/:id',
    //   builder: (context, state) {
    //     final id = state.pathParameters['id']!;
    //     return ProfilesScreen(usuarioId: id);
    //   },
    // ),
  ],
);
