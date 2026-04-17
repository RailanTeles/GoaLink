import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/core/input_personalizado.dart';
import 'package:provider/provider.dart';
import 'package:goalink/screens/login/login_view_model.dart';

class PainelInferior extends StatefulWidget {
  const PainelInferior({super.key, required this.alturaContainer});
  final double alturaContainer;

  @override
  State<PainelInferior> createState() => _PainelInferiorState();
}

class _PainelInferiorState extends State<PainelInferior> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final viewModel = context.read<LoginViewModel>();
    String? erro = await viewModel.fazerLogin(
      _emailController.text,
      _senhaController.text,
    );

    if (!mounted) return;

    if (erro == null) {
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select((LoginViewModel vm) => vm.isLoading);

    return AnimatedContainer(
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
                InputPersonalizado(
                  labelText: 'Email',
                  prefixIcon: Icons.email,
                  controller: _emailController,
                ),
                Column(
                  crossAxisAlignment: .end,
                  children: [
                    InputPersonalizado(
                      labelText: 'Senha',
                      prefixIcon: Icons.password,
                      controller: _senhaController,
                      isPassword: true,
                    ),
                    SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        context.go('/recuperar-senha');
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
                        onPressed: isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          disabledBackgroundColor: Colors.white.withValues(
                            alpha: 0.50,
                          ),
                          disabledForegroundColor: Colors.black.withValues(
                            alpha: 0.50,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
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
                        context.go('/cadastro/funcao');
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
    );
  }
}
