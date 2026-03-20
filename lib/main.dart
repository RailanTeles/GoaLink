import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _alturaContainer = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _alturaContainer = 500.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logo.png"),
                  SizedBox(width: 10),
                  Text.rich(
                    TextSpan(
                      // Estilo base que vale para "Goa" e para "Link"
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Goa',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'Link',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutQuart,
              width: double.infinity,
              height: _alturaContainer,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: const SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: SizedBox(height: 500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
