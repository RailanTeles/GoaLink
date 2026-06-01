import 'package:flutter/material.dart';
import 'package:goalink/screens/settings/settings_view_model.dart';
import 'package:goalink/screens/settings/widgets/settings_primary_button.dart';
import 'package:provider/provider.dart';

class NotificationsForm extends StatefulWidget {
  const NotificationsForm({super.key});

  @override
  State<NotificationsForm> createState() => _NotificationsFormState();
}

class _NotificationsFormState extends State<NotificationsForm> {
  bool _clubInterest = false;
  bool _messages = false;
  bool _updates = false;

  @override
  void initState() {
    super.initState();
    final vm = context.read<SettingsViewModel>();
    final prefs = vm.usuario?.preferenciasNotificacao ?? {};

    _clubInterest = prefs['interesseClubes'] ?? false;
    _messages = prefs['mensagens'] ?? false;
    _updates = prefs['atualizacoes'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Receber notificações:',
          style: TextStyle(
            color: Color(0xFF1B5E20),
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        _NotificationCheckboxTile(
          label: 'Interesse de clubes',
          value: _clubInterest,
          onChanged: (value) => setState(() => _clubInterest = value ?? false),
        ),
        _NotificationCheckboxTile(
          label: 'Mensagens',
          value: _messages,
          onChanged: (value) => setState(() => _messages = value ?? false),
        ),
        _NotificationCheckboxTile(
          label: 'Atualizações',
          value: _updates,
          onChanged: (value) => setState(() => _updates = value ?? false),
        ),
        const SizedBox(height: 12),
        SettingsPrimaryButton(
          label: vm.isSalvingPreferences ? 'Salvando...' : 'Confirmar',
          onPressed: vm.isSalvingPreferences ? null : _saveSettings,
        ),
      ],
    );
  }

  Future<void> _saveSettings() async {
    final messenger = ScaffoldMessenger.of(context);
    final vm = context.read<SettingsViewModel>();

    final sucesso = await vm.atualizarPreferenciasNotificacao(
      _clubInterest,
      _messages,
      _updates,
    );

    if (!mounted) return;

    messenger.clearSnackBars();
    if (sucesso) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(vm.sucessoSnackBar!),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(vm.erroSnackBar!), backgroundColor: Colors.red),
      );
    }
  }
}

class _NotificationCheckboxTile extends StatelessWidget {
  const _NotificationCheckboxTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1B1B1B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Checkbox(
            value: value,
            onChanged: onChanged,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: const BorderSide(color: Color(0xFF626262)),
            activeColor: const Color(0xFF1B5E20),
          ),
        ],
      ),
    );
  }
}
