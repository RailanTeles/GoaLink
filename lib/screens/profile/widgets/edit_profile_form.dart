import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/screens/profile/widgets/settings_primary_button.dart';
import 'package:goalink/screens/profile/widgets/settings_text_field.dart';
import 'package:goalink/services/profile_settings_service.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  late final List<TextEditingController> _controllers;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = true;
  bool _isSaving = false;
  UsuarioModel? _currentProfile;
  String? _selectedPhotoPath;
  String? _selectedVideoPath;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(9, (_) => TextEditingController());
    _loadProfile();
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
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

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
        SettingsTextField(label: 'Posicao', controller: _controllers[6]),
        SettingsTextField(label: 'Perna Preferida', controller: _controllers[7]),
        SettingsTextField(
          label: 'Bio',
          controller: _controllers[8],
          maxLines: 4,
        ),
        const SizedBox(height: 2),
        _MediaPickerButton(
          icon: Icons.camera_alt_outlined,
          label: _selectedPhotoPath == null
              ? 'Insira a foto aqui'
              : 'Foto selecionada: ${_fileName(_selectedPhotoPath)}',
          onPressed: _pickPhoto,
        ),
        const SizedBox(height: 10),
        _MediaPickerButton(
          icon: Icons.videocam_outlined,
          label: _selectedVideoPath == null
              ? 'Insira o video aqui'
              : 'Video selecionado: ${_fileName(_selectedVideoPath)}',
          onPressed: _pickVideo,
        ),
        const SizedBox(height: 16),
        SettingsPrimaryButton(
          label: _isSaving ? 'Salvando...' : 'Salvar Alteracoes',
          onPressed: _isSaving ? null : _saveProfile,
        ),
      ],
    );
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileSettingsService.instance.getProfile();

    _controllers[0].text = profile.nome;
    _controllers[1].text = profile.altura?.toString() ?? '';
    _controllers[2].text = profile.peso?.toString() ?? '';
    _controllers[3].text = profile.cidade ?? '';
    _controllers[4].text = _formatDate(profile.dataNascimento);
    _controllers[5].text = profile.cpf ?? '';
    _controllers[6].text = profile.posicao ?? '';
    _controllers[7].text = profile.pernaPreferida ?? '';
    _controllers[8].text = profile.descricao ?? '';

    if (!mounted) {
      return;
    }

    setState(() {
      _currentProfile = profile;
      _selectedPhotoPath = profile.fotoPerfil;
      _selectedVideoPath = profile.videoPerfil;
      _isLoading = false;
    });
  }

  Future<void> _pickPhoto() async {
    final photo = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (photo == null || !mounted) {
      return;
    }

    setState(() => _selectedPhotoPath = photo.path);
  }

  Future<void> _pickVideo() async {
    final video = await _imagePicker.pickVideo(source: ImageSource.gallery);

    if (video == null || !mounted) {
      return;
    }

    setState(() => _selectedVideoPath = video.path);
  }

  Future<void> _saveProfile() async {
    final currentProfile = _currentProfile;

    if (currentProfile == null) {
      return;
    }

    setState(() => _isSaving = true);

    final updatedProfile = currentProfile.copyWith(
      nome: _controllers[0].text.trim(),
      altura: _parseDouble(_controllers[1].text),
      peso: _parseDouble(_controllers[2].text),
      cidade: _controllers[3].text.trim(),
      dataNascimento: _parseDate(_controllers[4].text),
      cpf: _emptyToNull(_controllers[5].text),
      posicao: _emptyToNull(_controllers[6].text),
      pernaPreferida: _emptyToNull(_controllers[7].text),
      descricao: _emptyToNull(_controllers[8].text),
      fotoPerfil: _selectedPhotoPath,
      videoPerfil: _selectedVideoPath,
    );

    await ProfileSettingsService.instance.saveProfile(updatedProfile);

    if (!mounted) {
      return;
    }

    setState(() {
      _currentProfile = updatedProfile;
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil salvo com sucesso.')),
    );
  }

  double? _parseDouble(String value) {
    final sanitized = value.trim().replaceAll(',', '.');
    if (sanitized.isEmpty) {
      return null;
    }

    return double.tryParse(sanitized);
  }

  DateTime? _parseDate(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final parts = trimmed.split('/');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);

      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }

    return DateTime.tryParse(trimmed);
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _fileName(String? path) {
    if (path == null || path.isEmpty) {
      return '';
    }

    return path.split(RegExp(r'[\\/]')).last;
  }
}

class _MediaPickerButton extends StatelessWidget {
  const _MediaPickerButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF4F4F4F),
        backgroundColor: const Color(0xFFEAEAEA),
        side: const BorderSide(color: Color(0xFFBDBDBD)),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
