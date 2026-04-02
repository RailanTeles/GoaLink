import 'package:flutter/material.dart';
import 'package:goalink/screens/profile/widgets/settings_primary_button.dart';
import 'package:goalink/screens/profile/widgets/settings_text_field.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  late final List<TextEditingController> _controllers;

  static const List<String> _fieldLabels = [
    'Nome',
    'Altura',
    'Peso',
    'Cidade',
    'Data de Nascimento',
    'CPF',
    'Posição',
    'Perna Preferida',
    'Bio',
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_fieldLabels.length, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsTextField(label: 'Nome', controller: _controllers[0]),
        Row(
          children: [
            Expanded(
              child: SettingsTextField(
                label: 'Altura',
                controller: _controllers[1],
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SettingsTextField(
                label: 'Peso',
                controller: _controllers[2],
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        SettingsTextField(label: 'Cidade', controller: _controllers[3]),
        SettingsTextField(
          label: 'Data de Nascimento',
          controller: _controllers[4],
          keyboardType: TextInputType.datetime,
        ),
        SettingsTextField(
          label: 'CPF',
          controller: _controllers[5],
          keyboardType: TextInputType.number,
        ),
        SettingsTextField(label: 'Posição', controller: _controllers[6]),
        SettingsTextField(label: 'Perna Preferida', controller: _controllers[7]),
        SettingsTextField(
          label: 'Bio',
          controller: _controllers[8],
          maxLines: 4,
        ),
        const SizedBox(height: 2),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.camera_alt_outlined),
          label: const Text('Insira a foto aqui'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF4F4F4F),
            backgroundColor: const Color(0xFFEAEAEA),
            side: const BorderSide(color: Color(0xFFBDBDBD)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const SettingsPrimaryButton(label: 'Salvar Alterações'),
      ],
    );
  }
}
