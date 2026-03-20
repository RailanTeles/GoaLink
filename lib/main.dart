import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goalink/screens/login_screen.dart';

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
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: const Color(0xFF195E3B)),
        fontFamily: "MavenPro",
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
