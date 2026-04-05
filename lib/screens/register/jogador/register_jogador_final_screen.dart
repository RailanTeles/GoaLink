import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:goalink/screens/register/widgets/register_background.dart';
import 'package:goalink/screens/register/widgets/register_error_banner.dart';
import 'package:goalink/screens/register/widgets/register_form_panel.dart';
import 'package:goalink/screens/register/widgets/register_header.dart';
import 'package:goalink/screens/register/widgets/register_input_field.dart';
import 'package:goalink/screens/register/widgets/register_primary_button.dart';

class RegisterJogadorFinalScreen extends StatefulWidget {
  const RegisterJogadorFinalScreen({super.key});

  @override
  State<RegisterJogadorFinalScreen> createState() =>
      _RegisterJogadorFinalScreenState();
}

class _RegisterJogadorFinalScreenState
    extends State<RegisterJogadorFinalScreen> {
  static const List<String> _pernasPreferidas = [
    'Direita',
    'Esquerda',
    'Ambidestro',
  ];

  final _pernaPreferidaController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _imagePicker = ImagePicker();
  bool _showErrors = false;
  XFile? _profileImage;

  bool get _isFormValid {
    return _pernaPreferidaController.text.trim().isNotEmpty &&
        _descricaoController.text.trim().isNotEmpty;
  }

  String? get _validationMessage {
    return _isFormValid
        ? null
        : 'Complete os dados obrigatórios antes de criar a conta.';
  }

  void _refreshForm() => setState(() {});

  Future<void> _selectPernaPreferida() async {
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
            itemCount: _pernasPreferidas.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              color: Colors.white.withValues(alpha: 0.08),
            ),
            itemBuilder: (context, index) {
              final perna = _pernasPreferidas[index];
              return ListTile(
                title: Text(
                  perna,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: _pernaPreferidaController.text == perna
                    ? Icon(
                        Icons.check_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () => Navigator.of(context).pop(perna),
              );
            },
          ),
        );
      },
    );

    if (selected == null) return;
    _pernaPreferidaController.text = selected;
  }

  Future<void> _pickProfileImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (pickedFile == null || !mounted) return;
    setState(() {
      _profileImage = pickedFile;
    });
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
                        RegisterFormPanel(
                          radius: 4,
                          alpha: 0.24,
                          padding: const EdgeInsets.fromLTRB(14, 16, 14, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RegisterHeader(
                                title: 'Jogador',
                                iconSize: 118,
                                topSpacing: 16,
                                onBack: () => context.go('/cadastro/jogador-2'),
                              ),
                              const SizedBox(height: 28),
                              RegisterInputField(
                                label: 'Perna Preferida',
                                controller: _pernaPreferidaController,
                                readOnly: true,
                                onTap: _selectPernaPreferida,
                                hintText: 'Selecione uma opção',
                                suffixIcon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 22),
                              RegisterInputField(
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
                                  onPressed: _pickProfileImage,
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.photo_camera_outlined,
                                        size: 30,
                                      ),
                                      const SizedBox(width: 14),
                                      Flexible(
                                        child: Text(
                                          _profileImage?.name ??
                                              'Insira a foto aqui',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 80),
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
