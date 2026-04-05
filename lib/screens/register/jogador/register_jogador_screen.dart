import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/screens/register/widgets/register_background.dart';
import 'package:goalink/screens/register/widgets/register_error_banner.dart';
import 'package:goalink/screens/register/widgets/register_header.dart';
import 'package:goalink/screens/register/widgets/register_input_field.dart';
import 'package:goalink/screens/register/widgets/register_primary_button.dart';

class RegisterJogadorScreen extends StatefulWidget {
  const RegisterJogadorScreen({super.key});

  @override
  State<RegisterJogadorScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterJogadorScreen> {
  final _emailController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _showErrors = false;

  bool get _isFormValid {
    final email = _emailController.text.trim();
    final birthDate = _birthDateController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    return _isValidEmail(email) &&
        _isValidBirthDate(birthDate) &&
        password.length >= 6 &&
        confirmPassword == password;
  }

  String? get _validationMessage {
    return _isFormValid
        ? null
        : 'Preencha todos os campos corretamente para continuar.';
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  bool _isValidBirthDate(String value) {
    final match = RegExp(r'^(\d{2})\/(\d{2})\/(\d{4})$').firstMatch(value);
    if (match == null) return false;

    final day = int.tryParse(match.group(1)!);
    final month = int.tryParse(match.group(2)!);
    final year = int.tryParse(match.group(3)!);
    if (day == null || month == null || year == null) return false;
    if (month < 1 || month > 12 || day < 1) return false;

    final date = DateTime.tryParse(
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}',
    );

    return date != null &&
        date.day == day &&
        date.month == month &&
        date.year == year &&
        !date.isAfter(DateTime.now());
  }

  void _refreshForm() => setState(() {});

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_refreshForm);
    _birthDateController.addListener(_refreshForm);
    _passwordController.addListener(_refreshForm);
    _confirmPasswordController.addListener(_refreshForm);
  }

  @override
  void dispose() {
    _emailController.removeListener(_refreshForm);
    _birthDateController.removeListener(_refreshForm);
    _passwordController.removeListener(_refreshForm);
    _confirmPasswordController.removeListener(_refreshForm);
    _emailController.dispose();
    _birthDateController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RegisterHeader(
                          title: 'Jogador',
                          topSpacing: 20,
                          iconSize: 110,
                          onBack: () => context.go('/cadastro/funcao'),
                        ),
                        const SizedBox(height: 40),
                        RegisterInputField(
                          label: 'Email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 24),
                        RegisterInputField(
                          label: 'Data de Nascimento',
                          controller: _birthDateController,
                          hintText: 'DD/MM/AAAA',
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            _DateInputFormatter(),
                          ],
                        ),
                        const SizedBox(height: 24),
                        RegisterInputField(
                          label: 'Senha',
                          controller: _passwordController,
                          obscureText: !_showPassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() => _showPassword = !_showPassword);
                            },
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        RegisterInputField(
                          label: 'Confirmar Senha',
                          controller: _confirmPasswordController,
                          obscureText: !_showConfirmPassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(
                                () =>
                                    _showConfirmPassword = !_showConfirmPassword,
                              );
                            },
                            icon: Icon(
                              _showConfirmPassword
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
                              context.go('/cadastro/jogador-2');
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

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final limited = digitsOnly.length > 8
        ? digitsOnly.substring(0, 8)
        : digitsOnly;

    final buffer = StringBuffer();
    for (var i = 0; i < limited.length; i++) {
      buffer.write(limited[i]);
      if ((i == 1 || i == 3) && i < limited.length - 1) {
        buffer.write('/');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
