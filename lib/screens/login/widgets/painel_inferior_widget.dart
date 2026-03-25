import 'package:flutter/material.dart';

class PainelInferior extends StatefulWidget {
  const PainelInferior({super.key, required this.alturaContainer});
  final double alturaContainer;

  @override
  State<PainelInferior> createState() => _PainelInferiorState();
}

class _PainelInferiorState extends State<PainelInferior> {
  bool _ocultarSenha = true;

  @override
  Widget build(BuildContext context) {
    final alturaTeclado = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: alturaTeclado),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOutQuart,
        width: double.infinity,
        height: widget.alturaContainer,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.75),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 35.0),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: SizedBox(
              height: 480,
              width: .infinity,
              child: Column(
                mainAxisAlignment: .spaceEvenly,
                crossAxisAlignment: .center,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0, // Mantém grosso quando clica
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: .end,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: TextFormField(
                          obscureText: _ocultarSenha,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                            labelText: 'Senha',
                            prefixIcon: const Icon(
                              Icons.password,
                              color: Colors.white,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _ocultarSenha = !_ocultarSenha;
                                });
                              },
                              icon: Icon(
                                _ocultarSenha
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white54,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2.0, // Mantém grosso quando clica
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextButton(
                        onPressed: () {
                          // Navegar para esqueci minha senha
                        },
                        child: Text(
                          "Esqueci minha senha",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: .w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Ação de login aqui
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
                            "Entrar",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          // Navegar para cadastrar
                        },
                        child: Text.rich(
                          TextSpan(
                            style: const TextStyle(fontWeight: FontWeight.w700),
                            children: [
                              const TextSpan(
                                text: 'Não tem conta? ',
                                style: TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: 'Cadastre-se!',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
