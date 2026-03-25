import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goalink/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoaLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: const Color(0xFF195E3B)),
        fontFamily: "MavenPro",
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
