import 'package:flutter/material.dart';
import 'package:goalink/screens/profile/widgets/settings_primary_button.dart';
import 'package:goalink/screens/profile/widgets/settings_text_field.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsTextField(
          label: 'Senha Antiga',
          controller: _oldPasswordController,
          obscureText: true,
        ),
        SettingsTextField(
          label: 'Nova Senha',
          controller: _newPasswordController,
          obscureText: true,
        ),
        SettingsTextField(
          label: 'Confirmar',
          controller: _confirmPasswordController,
          obscureText: true,
        ),
        const SizedBox(height: 4),
        const SettingsPrimaryButton(label: 'Alterar Senha'),
      ],
    );
  }
}
