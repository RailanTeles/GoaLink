import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/screens/register/widgets/register_background.dart';
import 'package:goalink/screens/register/widgets/register_error_banner.dart';
import 'package:goalink/screens/register/widgets/register_form_panel.dart';
import 'package:goalink/screens/register/widgets/register_header.dart';
import 'package:goalink/screens/register/widgets/register_input_field.dart';
import 'package:goalink/screens/register/widgets/register_primary_button.dart';

class RegisterClubeFinalScreen extends StatefulWidget {
  const RegisterClubeFinalScreen({super.key});

  @override
  State<RegisterClubeFinalScreen> createState() =>
      _RegisterClubeFinalScreenState();
}

class _RegisterClubeFinalScreenState extends State<RegisterClubeFinalScreen> {
  final _cidadeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _jogadoresController = TextEditingController();
  bool _showErrors = false;

  bool get _isFormValid {
    return _cidadeController.text.trim().isNotEmpty &&
        _descricaoController.text.trim().isNotEmpty &&
        _jogadoresController.text.trim().isNotEmpty;
  }

  String? get _validationMessage {
    return _isFormValid
        ? null
        : 'Complete os campos obrigatórios para criar a conta.';
  }

  void _refreshForm() => setState(() {});

  @override
  void initState() {
    super.initState();
    _cidadeController.addListener(_refreshForm);
    _descricaoController.addListener(_refreshForm);
    _jogadoresController.addListener(_refreshForm);
  }

  @override
  void dispose() {
    _cidadeController.removeListener(_refreshForm);
    _descricaoController.removeListener(_refreshForm);
    _jogadoresController.removeListener(_refreshForm);
    _cidadeController.dispose();
    _descricaoController.dispose();
    _jogadoresController.dispose();
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
                          onBack: () => context.go('/cadastro/clube'),
                        ),
                        const SizedBox(height: 28),
                        RegisterFormPanel(
                          radius: 4,
                          alpha: 0.24,
                          padding: const EdgeInsets.fromLTRB(14, 16, 14, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RegisterInputField(
                                label: 'Cidade',
                                controller: _cidadeController,
                              ),
                              const SizedBox(height: 24),
                              RegisterInputField(
                                label: 'Descrição',
                                controller: _descricaoController,
                                maxLines: 5,
                                minLines: 5,
                              ),
                              const SizedBox(height: 24),
                              RegisterInputField(
                                label: 'Jogadores que procura',
                                controller: _jogadoresController,
                                maxLines: 4,
                                minLines: 4,
                              ),
                              const SizedBox(height: 36),
                              RegisterPrimaryButton(
                                label: 'Criar Conta',
                                onPressed: () {
                                  setState(() {
                                    _showErrors = true;
                                  });
                                  if (_isFormValid) {
                                    context.go('/login');
                                  }
                                },
                              ),
                              if (_showErrors && _validationMessage != null) ...[
                                const SizedBox(height: 14),
                                RegisterErrorBanner(
                                  message: _validationMessage!,
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
      ),
    );
  }
}
