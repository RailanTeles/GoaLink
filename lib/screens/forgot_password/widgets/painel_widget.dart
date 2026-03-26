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
    final alturaTela = MediaQuery.of(context).size.height;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.only(bottom: alturaTeclado),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutQuart,
        alignment: subir ? const Alignment(0, 0) : const Alignment(0, 1.2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutQuart,
          width: double.infinity,
          height: alturaTela,
          child: Container(
            width: double.infinity,
            height: alturaTela,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.75),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo + Goalink lado a lado
                  Row(
                  mainAxisAlignment: .center,
                  children: [
                    Image.asset("assets/images/logo.png"),
                    SizedBox(width: 10),
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

                  // Texto explicativo
                  const Text(
                    "Digite o e-mail cadastrado para \n redefinir sua senha.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Input
                  InputPersonalizado(
                    labelText: 'Email',
                    prefixIcon: Icons.email,
                    controller: _emailController,
                  ),

                  const SizedBox(height: 30),

                  // Botão
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/');
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

                  // Espaço extra para teclado
                  SizedBox(height: alturaTeclado),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}