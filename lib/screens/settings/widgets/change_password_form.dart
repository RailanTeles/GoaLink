import 'package:flutter/material.dart';
import 'package:goalink/screens/settings/widgets/settings_primary_button.dart';
import 'package:goalink/screens/settings/widgets/settings_text_field.dart';
import 'package:goalink/services/profile_settings_service.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSaving = false;

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
          label: 'Confirmar Nova Senha',
          controller: _confirmPasswordController,
          obscureText: true,
        ),
        const SizedBox(height: 4),
        SettingsPrimaryButton(
          label: _isSaving ? 'Salvando...' : 'Alterar Senha',
          onPressed: _isSaving ? null : _savePassword,
        ),
      ],
    );
  }

  Future<void> _savePassword() async {
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showMessage('Preencha todos os campos.');
      return;
    }

    if (newPassword != confirmPassword) {
      _showMessage('A nova senha e a confirmacao nao coincidem.');
      return;
    }

    setState(() => _isSaving = true);

    final changed = await ProfileSettingsService.instance.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );

    if (!mounted) {
      return;
    }

    setState(() => _isSaving = false);

    if (!changed) {
      _showMessage('A senha antiga informada esta incorreta.');
      return;
    }

    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    _showMessage('Senha alterada com sucesso.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
