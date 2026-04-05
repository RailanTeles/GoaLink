import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/screens/register/widgets/register_background.dart';
import 'package:goalink/screens/register/widgets/register_error_banner.dart';
import 'package:goalink/screens/register/widgets/register_form_panel.dart';
import 'package:goalink/screens/register/widgets/register_header.dart';
import 'package:goalink/screens/register/widgets/register_input_field.dart';
import 'package:goalink/screens/register/widgets/register_primary_button.dart';

class RegisterJogadorSegundoScreen extends StatefulWidget {
  const RegisterJogadorSegundoScreen({super.key});

  @override
  State<RegisterJogadorSegundoScreen> createState() =>
      _RegisterJogadorSegundoScreenState();
}

class _RegisterJogadorSegundoScreenState
    extends State<RegisterJogadorSegundoScreen> {
  static const List<String> _posicoes = [
    'Goleiro',
    'Zagueiro',
    'Lateral direito',
    'Lateral esquerdo',
    'Volante',
    'Meio-campo',
    'Meia ofensivo',
    'Ponta direita',
    'Ponta esquerda',
    'Atacante',
    'Centroavante',
  ];

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
        altura >= 0.5 &&
        altura <= 3.0 &&
        peso != null &&
        peso >= 20 &&
        peso <= 300 &&
        cidade.isNotEmpty &&
        posicao.isNotEmpty;
  }

  String? get _validationMessage {
    return _isFormValid
        ? null
        : 'Há campos faltando ou inválidos. Revise para continuar.';
  }

  void _refreshForm() => setState(() {});

  Future<void> _selectPosicao() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF101010),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: _posicoes.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              color: Colors.white.withValues(alpha: 0.08),
            ),
            itemBuilder: (context, index) {
              final posicao = _posicoes[index];
              return ListTile(
                title: Text(
                  posicao,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: _posicaoController.text == posicao
                    ? Icon(
                        Icons.check_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () => Navigator.of(context).pop(posicao),
              );
            },
          ),
        );
      },
    );

    if (selected == null) return;
    _posicaoController.text = selected;
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
                          title: 'Jogador',
                          iconSize: 108,
                          topSpacing: 20,
                          onBack: () => context.go('/cadastro'),
                        ),
                        const SizedBox(height: 28),
                        RegisterFormPanel(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RegisterInputField(
                                label: 'Nome',
                                controller: _nomeController,
                              ),
                              const SizedBox(height: 22),
                              RegisterInputField(
                                label: 'Altura',
                                controller: _alturaController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                hintText: 'Em metros, ex: 1,80',
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.,]'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 22),
                              RegisterInputField(
                                label: 'Peso',
                                controller: _pesoController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                hintText: 'Em kg, ex: 75',
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.,]'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 22),
                              RegisterInputField(
                                label: 'Cidade',
                                controller: _cidadeController,
                              ),
                              const SizedBox(height: 22),
                              RegisterInputField(
                                label: 'Posição em campo',
                                controller: _posicaoController,
                                readOnly: true,
                                onTap: _selectPosicao,
                                hintText: 'Selecione uma posição',
                                suffixIcon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 28),
                              RegisterPrimaryButton(
                                label: 'Seguinte',
                                onPressed: () {
                                  setState(() {
                                    _showErrors = true;
                                  });
                                  if (_isFormValid) {
                                    context.go('/cadastro/jogador-3');
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
