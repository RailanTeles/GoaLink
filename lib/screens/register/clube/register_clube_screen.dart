import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/screens/register/widgets/register_background.dart';
import 'package:goalink/screens/register/widgets/register_error_banner.dart';
import 'package:goalink/screens/register/widgets/register_header.dart';
import 'package:goalink/screens/register/widgets/register_input_field.dart';
import 'package:goalink/screens/register/widgets/register_primary_button.dart';

class RegisterClubeScreen extends StatefulWidget {
  const RegisterClubeScreen({super.key});

  @override
  State<RegisterClubeScreen> createState() => _RegisterClubeScreenState();
}

class _RegisterClubeScreenState extends State<RegisterClubeScreen> {
  final _nomeClubeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool _showSenha = false;
  bool _showConfirmarSenha = false;
  bool _showErrors = false;

  bool get _isFormValid {
    final nomeClube = _nomeClubeController.text.trim();
    final email = _emailController.text.trim();
    final senha = _senhaController.text;
    final confirmarSenha = _confirmarSenhaController.text;

    return nomeClube.isNotEmpty &&
        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email) &&
        senha.length >= 6 &&
        confirmarSenha == senha;
  }

  String? get _validationMessage {
    return _isFormValid
        ? null
        : 'Preencha todos os campos corretamente para continuar.';
  }

  void _refreshForm() => setState(() {});

  @override
  void initState() {
    super.initState();
    _nomeClubeController.addListener(_refreshForm);
    _emailController.addListener(_refreshForm);
    _senhaController.addListener(_refreshForm);
    _confirmarSenhaController.addListener(_refreshForm);
  }

  @override
  void dispose() {
    _nomeClubeController.removeListener(_refreshForm);
    _emailController.removeListener(_refreshForm);
    _senhaController.removeListener(_refreshForm);
    _confirmarSenhaController.removeListener(_refreshForm);
    _nomeClubeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RegisterBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RegisterHeader(
                          title: 'Clube',
                          iconSize: 120,
                          onBack: () {
                            if (context.canPop()) {
                              context.pop();
                              return;
                            }
                            context.go('/cadastro/funcao');
                          },
                        ),
                        const SizedBox(height: 34),
                        RegisterInputField(
                          label: 'Nome do Clube',
                          controller: _nomeClubeController,
                        ),
                        const SizedBox(height: 24),
                        RegisterInputField(
                          label: 'E-mail',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 24),
                        RegisterInputField(
                          label: 'Senha',
                          controller: _senhaController,
                          obscureText: !_showSenha,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() => _showSenha = !_showSenha);
                            },
                            icon: Icon(
                              _showSenha
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        RegisterInputField(
                          label: 'Confirmar Senha',
                          controller: _confirmarSenhaController,
                          obscureText: !_showConfirmarSenha,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(
                                () =>
                                    _showConfirmarSenha = !_showConfirmarSenha,
                              );
                            },
                            icon: Icon(
                              _showConfirmarSenha
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(height: 36),
                        RegisterPrimaryButton(
                          label: 'Seguinte',
                          onPressed: () {
                            setState(() {
                              _showErrors = true;
                            });
                            if (_isFormValid) {
                              context.go('/cadastro/clube-final');
                            }
                          },
                        ),
                        if (_showErrors && _validationMessage != null) ...[
                          const SizedBox(height: 14),
                          RegisterErrorBanner(message: _validationMessage!),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
