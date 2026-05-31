import 'package:flutter/material.dart';
import 'package:goalink/screens/settings/settings_view_model.dart';
import 'package:goalink/screens/settings/widgets/settings_primary_button.dart';
import 'package:goalink/screens/settings/widgets/settings_text_field.dart';
import 'package:provider/provider.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _handleAlterarSenha() async {
    final vm = context.read<SettingsViewModel>();
    await vm.alterarSenha(
      _oldPasswordController.text,
      _newPasswordController.text,
      _confirmPasswordController.text,
    );

    if (vm.erroSnackBar == null && vm.sucessoSnackBar != null) {
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsViewModel>();
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
          label: vm.isSalvingPassword ? 'Alterando...' : 'Alterar Senha',
          onPressed: vm.isSalvingPassword ? null : _handleAlterarSenha,
        ),
      ],
    );
  }
}
