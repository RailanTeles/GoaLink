import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/screens/settings/settings_view_model.dart';
import 'package:goalink/screens/settings/widgets/settings_primary_button.dart';
import 'package:goalink/screens/settings/widgets/settings_text_field.dart';
import 'package:provider/provider.dart';

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

  Future<bool?> _mostrarDialogoConfirmacao(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Excluir conta permanentemente?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Esta ação é irreversível. Todas as suas postagens, favoritos, '
            'conversas e dados do perfil serão apagados para sempre.\n\n'
            'Tem certeza de que deseja continuar?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFD32F2F),
              ),
              child: const Text('Sim, excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SettingsViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Digite sua senha para deletar a conta',
          style: TextStyle(
            color: Color(0xFFD32F2F),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SettingsTextField(
          label: 'Senha',
          controller: _passwordController,
          obscureText: true,
        ),
        const SizedBox(height: 4),
        SettingsPrimaryButton(
          label: 'Deletar Conta',
          backgroundColor: Color(0xFFD32F2F),
          onPressed: viewModel.isSalving
              ? null
              : () async {
                  FocusScope.of(context).unfocus();

                  final messenger = ScaffoldMessenger.of(context);
                  final router = GoRouter.of(context);

                  if (_passwordController.text.trim().isEmpty) {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Por favor, digite sua senha antes de continuar.',
                        ),
                      ),
                    );
                    return;
                  }

                  final confirmar = await _mostrarDialogoConfirmacao(context);
                  if (confirmar != true) return;

                  final sucesso = await viewModel.deletarConta(
                    _passwordController.text,
                  );

                  if (!mounted) return;

                  messenger.clearSnackBars();
                  if (sucesso) {
                    router.go('/login');
                  } else {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(viewModel.erroSnackBar!),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
        ),
      ],
    );
  }
}
