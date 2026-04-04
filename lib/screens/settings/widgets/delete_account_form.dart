import 'package:flutter/material.dart';
import 'package:goalink/screens/settings/widgets/settings_primary_button.dart';
import 'package:goalink/screens/settings/widgets/settings_text_field.dart';

class DeleteAccountForm extends StatefulWidget {
  const DeleteAccountForm({super.key});

  @override
  State<DeleteAccountForm> createState() => _DeleteAccountFormState();
}

class _DeleteAccountFormState extends State<DeleteAccountForm> {
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Digite sua senha para deletar a conta',
          style: TextStyle(
            color: Color(0xFF5F5F5F),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        SettingsTextField(
          label: 'Senha',
          controller: _passwordController,
          obscureText: true,
        ),
        const SizedBox(height: 4),
        const SettingsPrimaryButton(
          label: 'Deletar Conta',
          backgroundColor: Color(0xFFD32F2F),
        ),
      ],
    );
  }
}
