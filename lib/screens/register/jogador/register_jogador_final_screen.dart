import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterJogadorFinalScreen extends StatefulWidget {
  const RegisterJogadorFinalScreen({super.key});

  @override
  State<RegisterJogadorFinalScreen> createState() =>
      _RegisterJogadorFinalScreenState();
}

class _RegisterJogadorFinalScreenState
    extends State<RegisterJogadorFinalScreen> {
  final _pernaPreferidaController = TextEditingController();
  final _descricaoController = TextEditingController();
  bool _showErrors = false;

  bool get _isFormValid {
    return _pernaPreferidaController.text.trim().isNotEmpty &&
        _descricaoController.text.trim().isNotEmpty;
  }

  String? get _validationMessage {
    return _isFormValid
        ? null
        : 'Complete os dados obrigatórios antes de criar a conta.';
  }

  void _refreshForm() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _pernaPreferidaController.addListener(_refreshForm);
    _descricaoController.addListener(_refreshForm);
  }

  @override
  void dispose() {
    _pernaPreferidaController.removeListener(_refreshForm);
    _descricaoController.removeListener(_refreshForm);
    _pernaPreferidaController.dispose();
    _descricaoController.dispose();
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
                            'Cadastro (Joagador) 3',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.45),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(14, 16, 14, 20),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.24),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (context.canPop()) {
                                      context.pop();
                                      return;
                                    }
                                    context.go('/cadastro/jogador-2');
                                  },
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.10,
                                    ),
                                    foregroundColor: Colors.white,
                                    fixedSize: const Size(48, 48),
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                  ),
                                ),
                                const SizedBox(height: 16),
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
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
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
                                _RegisterField(
                                  label: 'Perna Preferida',
                                  controller: _pernaPreferidaController,
                                ),
                                const SizedBox(height: 22),
                                _RegisterField(
                                  label: 'Breve descrição sobre você',
                                  controller: _descricaoController,
                                  maxLines: 5,
                                  minLines: 5,
                                ),
                                const SizedBox(height: 22),
                                const Text(
                                  'Foto de Perfil',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color(0xFFD8D8D8),
                                      foregroundColor: Colors.black,
                                      side: BorderSide(
                                        color: Colors.white.withValues(
                                          alpha: 0.55,
                                        ),
                                        width: 2,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 18,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.photo_camera_outlined,
                                          size: 30,
                                        ),
                                        SizedBox(width: 14),
                                        Text(
                                          'Insira a foto aqui',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 80),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _showErrors = true;
                                      });
                                      if (_isFormValid) {}
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
                                      'Criar Conta',
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
    this.maxLines = 1,
    this.minLines,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;
  final int? minLines;

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
          maxLines: maxLines,
          minLines: minLines,
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
      width: 118,
      height: 118,
      fit: BoxFit.contain,
    );
  }
}
