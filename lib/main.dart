import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goalink/repositories/avaliacoes_repository.dart';
import 'package:goalink/repositories/postagem_repository.dart';
import 'package:goalink/repositories/usuario_repository.dart';
import 'package:goalink/routes.dart';
import 'package:goalink/services/auth_service.dart';
import 'package:goalink/services/avaliacao_service.dart';
import 'package:goalink/services/cache_service.dart';
import 'package:goalink/services/chat_mensagem_service.dart';
import 'package:goalink/services/favorito_service.dart';
import 'package:goalink/services/notificacao_service.dart';
import 'package:goalink/services/postagem_service.dart';
import 'package:goalink/services/storage_service.dart';
import 'package:goalink/services/usuario_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await CacheService.inicializarCache();

  runApp(
    MultiProvider(
      providers: [
        Provider<UsuarioRepository>(
          create: (_) => UsuarioRepository(
            AuthService(),
            PostagemService(),
            UsuarioService(),
            CacheService(),
            StorageService(),
            AvaliacaoService(),
            ChatMensagemService(),
            FavoritoService(),
            NotificacaoService(),
          ),
        ),
        Provider<PostagemRepository>(
          create: (_) => PostagemRepository(
            PostagemService(),
            CacheService(),
            StorageService(),
          ),
        ),
        Provider<AvaliacoesRepository>(
          create: (_) => AvaliacoesRepository(AvaliacaoService()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoaLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color(0xFF195E3B),
          secondary: const Color(0xFF022412),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: Colors.white),
          prefixIconColor: Colors.white,
          suffixIconColor: Colors.white54,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: Colors.white, width: 2.0),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: const Color(0xFF195E3B), width: 2.0),
          ),
        ),
        fontFamily: "MavenPro",
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
