import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/core/input_personalizado.dart';

class PainelInferior extends StatefulWidget {
  const PainelInferior({super.key, required this.alturaContainer});

  final double alturaContainer;

  @override
  State<PainelInferior> createState() => _PainelInferiorState();
}

class _PainelInferiorState extends State<PainelInferior> {
  final _emailController = TextEditingController();
  bool subir = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        subir = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final alturaTeclado = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: alturaTeclado),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutQuart,
        alignment: subir ? Alignment.bottomCenter : const Alignment(0, 1.2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutQuart,
          width: double.infinity,
          height: widget.alturaContainer,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.75),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: SizedBox(
              height: widget.alturaContainer,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          context.go('/login');
                        },
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/logo.png", height: 50),
                        const SizedBox(width: 10),
                        Text.rich(
                          TextSpan(
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
                    const SizedBox(height: 30),
                    const Text(
                      "Digite o e-mail cadastrado para \n redefinir sua senha.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(height: 30),
                    InputPersonalizado(
                      labelText: 'Email',
                      prefixIcon: Icons.email,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go("/login");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: const Text(
                          "Enviar",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
