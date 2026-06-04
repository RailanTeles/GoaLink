import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/providers/auth_provider.dart';
import 'package:goalink/repositories/avaliacoes_repository.dart';
import 'package:goalink/repositories/notificacoes_repository.dart';
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

  final cacheService = CacheService();
  final usuarioRepository = UsuarioRepository(
    AuthService(),
    PostagemService(),
    UsuarioService(),
    cacheService,
    StorageService(),
    AvaliacaoService(),
    ChatMensagemService(),
    FavoritoService(),
    NotificacaoService(),
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<UsuarioRepository>.value(value: usuarioRepository),
        Provider<CacheService>.value(value: cacheService),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(usuarioRepository, cacheService),
        ),
        Provider<PostagemRepository>(
          create: (_) => PostagemRepository(
            PostagemService(),
            cacheService,
            StorageService(),
          ),
        ),
        Provider<AvaliacoesRepository>(
          create: (_) => AvaliacoesRepository(AvaliacaoService()),
        ),
        Provider<NotificacoesRepository>(
          create: (_) => NotificacoesRepository(NotificacaoService()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoRouter _router;
  late final AuthProvider _authProvider;
  late final VoidCallback _authListener;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authProvider = context.read<AuthProvider>();
    _router = criarRouter(_authProvider);

    _authListener = () {
      if (mounted) {
        setState(() {
          _router = criarRouter(_authProvider);
        });
      }
    };
    _authProvider.addListener(_authListener);
  }

  @override
  void dispose() {
    _authProvider.removeListener(_authListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      key: ValueKey(_router.hashCode),
      title: 'GoaLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
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
      routerConfig: _router,
    );
  }
}
