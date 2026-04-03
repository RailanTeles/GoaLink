import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterJogadorSegundoScreen extends StatefulWidget {
  const RegisterJogadorSegundoScreen({super.key});

  @override
  State<RegisterJogadorSegundoScreen> createState() =>
      _RegisterJogadorSegundoScreenState();
}

class _RegisterJogadorSegundoScreenState
    extends State<RegisterJogadorSegundoScreen> {
  final _nomeController = TextEditingController();
  final _alturaController = TextEditingController();
  final _pesoController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _posicaoController = TextEditingController();
  bool _showErrors = false;

  bool get _isFormValid {
    final nome = _nomeController.text.trim();
    final altura = double.tryParse(_alturaController.text.replaceAll(',', '.'));
    final peso = double.tryParse(_pesoController.text.replaceAll(',', '.'));
    final cidade = _cidadeController.text.trim();
    final posicao = _posicaoController.text.trim();

    return nome.isNotEmpty &&
        altura != null &&
        altura > 0 &&
        peso != null &&
        peso > 0 &&
        cidade.isNotEmpty &&
        posicao.isNotEmpty;
  }

  String? get _validationMessage {
    return _isFormValid
        ? null
        : 'Há campos faltando ou inválidos. Revise para continuar.';
  }

  void _refreshForm() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _nomeController.addListener(_refreshForm);
    _alturaController.addListener(_refreshForm);
    _pesoController.addListener(_refreshForm);
    _cidadeController.addListener(_refreshForm);
    _posicaoController.addListener(_refreshForm);
  }

  @override
  void dispose() {
    _nomeController.removeListener(_refreshForm);
    _alturaController.removeListener(_refreshForm);
    _pesoController.removeListener(_refreshForm);
    _cidadeController.removeListener(_refreshForm);
    _posicaoController.removeListener(_refreshForm);
    _nomeController.dispose();
    _alturaController.dispose();
    _pesoController.dispose();
    _cidadeController.dispose();
    _posicaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background.png', fit: BoxFit.cover),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: Colors.black.withValues(alpha: 0.58)),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.72),
                  Colors.black.withValues(alpha: 0.86),
                  Colors.black.withValues(alpha: 0.94),
                ],
              ),
            ),
          ),
          SafeArea(
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
                          Text(
                            'Cadastro (Joagador) 2',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.45),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 14),
                          IconButton(
                            onPressed: () {
                              if (context.canPop()) {
                                context.pop();
                                return;
                              }
                              context.go('/cadastro');
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.10,
                              ),
                              foregroundColor: Colors.white,
                              fixedSize: const Size(48, 48),
                            ),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const _TacticalIcon(),
                                const SizedBox(width: 14),
                                Text.rich(
                                  TextSpan(
                                    style: const TextStyle(
                                      fontSize: 34,
                                      height: 1.05,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Cadastro\n',
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: 'Jogador',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(width: 14),
                                const _TacticalIcon(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.28),
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _RegisterField(
                                  label: 'Nome',
                                  controller: _nomeController,
                                ),
                                const SizedBox(height: 22),
                                _RegisterField(
                                  label: 'Altura',
                                  controller: _alturaController,
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 22),
                                _RegisterField(
                                  label: 'Peso',
                                  controller: _pesoController,
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 22),
                                _RegisterField(
                                  label: 'Cidade',
                                  controller: _cidadeController,
                                ),
                                const SizedBox(height: 22),
                                _RegisterField(
                                  label: 'Posição em campo',
                                  controller: _posicaoController,
                                ),
                                const SizedBox(height: 28),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _showErrors = true;
                                      });
                                      if (_isFormValid) {
                                        context.go('/cadastro/jogador-3');
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.colorScheme.primary,
                                      foregroundColor: Colors.black,
                                      elevation: 0,
                                      side: const BorderSide(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 18,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: const Text(
                                      'Seguinte',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                if (_showErrors &&
                                    _validationMessage != null) ...[
                                  const SizedBox(height: 14),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFC62828),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      _validationMessage!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterField extends StatelessWidget {
  const _RegisterField({
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.92),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 20,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.white, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _TacticalIcon extends StatelessWidget {
  const _TacticalIcon();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_app.png',
      width: 108,
      height: 108,
      fit: BoxFit.contain,
    );
  }
}
