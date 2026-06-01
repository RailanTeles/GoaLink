import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/screens/settings/settings_view_model.dart';
import 'package:goalink/screens/settings/widgets/settings_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key, required this.usuario});
  final UsuarioModel usuario;

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  // --- Controllers Base (Todos os tipos) ---
  late final TextEditingController _nomeController;
  late final TextEditingController _descricaoController;

  // --- Controllers Jogador ---
  late final TextEditingController _alturaController;
  late final TextEditingController _pesoController;
  late final TextEditingController _dataNascController;

  // --- Controllers Jogador e Clube ---
  late final TextEditingController _cidadeController;

  // --- Controllers Olheiro e Clube ---
  late final TextEditingController _jogadoresProcuradosController;
  late final TextEditingController _clubeRepresentanteController;

  // --- Controllers Redes Sociais ---
  late final TextEditingController _link1Controller;
  late final TextEditingController _link2Controller;
  late final TextEditingController _link3Controller;

  // --- Variáveis de Estado ---
  String? _selectedPosition;
  String? _selectedPreferredFoot;
  String? _selectedPhotoPath;
  bool _removerFoto = false;

  final ImagePicker _imagePicker = ImagePicker();

  static const List<String> _positions = [
    'Goleiro',
    'Zagueiro',
    'Lateral Direito',
    'Lateral Esquerdo',
    'Volante',
    'Meio-campo',
    'Meia Atacante',
    'Ponta Direita',
    'Ponta Esquerda',
    'Centroavante',
  ];

  static const List<String> _preferredFeet = [
    'Direita',
    'Esquerda',
    'Ambidestro',
  ];

  @override
  void initState() {
    super.initState();
    final u = widget.usuario;

    _nomeController = TextEditingController(text: u.nome);
    _descricaoController = TextEditingController(text: u.descricao ?? '');
    _alturaController = TextEditingController(text: u.altura?.toString() ?? '');
    _pesoController = TextEditingController(text: u.peso?.toString() ?? '');
    _cidadeController = TextEditingController(text: u.cidade ?? '');
    _jogadoresProcuradosController = TextEditingController(
      text: u.jogadoresProcurados ?? '',
    );
    _clubeRepresentanteController = TextEditingController(
      text: u.clubeRepresentante ?? '',
    );

    String dataNasc = '';
    if (u.dataNascimento != null) {
      final d = u.dataNascimento!;
      dataNasc =
          '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    }
    _dataNascController = TextEditingController(text: dataNasc);

    _selectedPosition = u.posicao;
    _selectedPreferredFoot = u.pernaPreferida;

    _link1Controller = TextEditingController();
    _link2Controller = TextEditingController();
    _link3Controller = TextEditingController();

    if (u.redesSociais != null && u.redesSociais!.isNotEmpty) {
      List<dynamic> urls = u.redesSociais!.values.toList();
      if (urls.isNotEmpty) _link1Controller.text = urls[0].toString();
      if (urls.length > 1) _link2Controller.text = urls[1].toString();
      if (urls.length > 2) _link3Controller.text = urls[2].toString();
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _alturaController.dispose();
    _pesoController.dispose();
    _dataNascController.dispose();
    _cidadeController.dispose();
    _jogadoresProcuradosController.dispose();
    _clubeRepresentanteController.dispose();
    _link1Controller.dispose();
    _link2Controller.dispose();
    _link3Controller.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedPhotoPath = pickedFile.path;
        _removerFoto = false;
      });
    }
  }

  ImageProvider? _obterImagemAvatar() {
    if (_selectedPhotoPath != null) {
      return FileImage(File(_selectedPhotoPath!));
    }

    if (widget.usuario.fotoUrl != null && !_removerFoto) {
      return NetworkImage(widget.usuario.fotoUrl!);
    }

    return null;
  }

  Map<String, dynamic>? _processarRedesSociais() {
    Map<String, dynamic> redes = {};
    List<String> links = [
      _link1Controller.text.trim(),
      _link2Controller.text.trim(),
      _link3Controller.text.trim(),
    ];

    int contagemGenerica = 1;

    for (String link in links) {
      if (link.isEmpty) continue;

      String linkMin = link.toLowerCase();
      String chave = '';

      if (linkMin.contains('instagram.com')) {
        chave = 'instagram';
      } else if (linkMin.contains('twitter.com') || linkMin.contains('x.com')) {
        chave = 'twitter';
      } else if (linkMin.contains('youtube.com') ||
          linkMin.contains('youtu.be')) {
        chave = 'youtube';
      } else if (linkMin.contains('tiktok.com')) {
        chave = 'tiktok';
      } else if (linkMin.contains('facebook.com')) {
        chave = 'facebook';
      } else if (linkMin.contains('linkedin.com')) {
        chave = 'linkedin';
      } else {
        chave = 'site_$contagemGenerica';
        contagemGenerica++;
      }
      if (redes.containsKey(chave)) {
        chave = '${chave}_$contagemGenerica';
        contagemGenerica++;
      }
      redes[chave] = link;
    }

    return redes.isEmpty ? null : redes;
  }

  void _saveProfile() async {
    FocusScope.of(context).unfocus();
    final nome = _nomeController.text.trim();
    final tipo = widget.usuario.tipo;

    final messenger = ScaffoldMessenger.of(context);
    final vm = context.read<SettingsViewModel>();

    if (nome.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('O nome é obrigatório!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final sucesso = await vm.editarUsuario(
      nome,
      tipo == 'jogador' ? _alturaController.text.trim() : null,
      tipo == 'jogador' ? _pesoController.text.trim() : null,
      (tipo == 'jogador' || tipo == 'clube')
          ? _cidadeController.text.trim()
          : null,
      tipo == 'jogador' ? _dataNascController.text.trim() : null,
      tipo == 'jogador' ? _selectedPosition : null,
      tipo == 'jogador' ? _selectedPreferredFoot : null,
      _descricaoController.text.trim(),
      _selectedPhotoPath,
      _processarRedesSociais(),
      tipo == 'olheiro' ? _clubeRepresentanteController.text.trim() : null,
      (tipo == 'olheiro' || tipo == 'clube')
          ? _jogadoresProcuradosController.text.trim()
          : null,
      _removerFoto,
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
        SnackBar(
          content: Text(vm.erroSnackBar ?? 'Erro desconhecido'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSalving = context.select<SettingsViewModel, bool>(
      (vm) => vm.isSalving,
    );
    final tipo = widget.usuario.tipo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- AVATAR ---
        Center(
          child: Stack(
            children: [
              GestureDetector(
                onTap: _pickPhoto,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _obterImagemAvatar(),
                  child: _obterImagemAvatar() == null
                      ? Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey.shade500,
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickPhoto,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF195E3B),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        if (_selectedPhotoPath != null ||
            (widget.usuario.fotoUrl != null && !_removerFoto))
          Center(
            child: TextButton(
              onPressed: () => setState(() {
                _selectedPhotoPath = null;
                _removerFoto = true;
              }),
              child: const Text(
                'Remover Foto',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),

        const SizedBox(height: 24),

        // --- CAMPOS BASE ---
        SettingsTextField(label: 'Nome', controller: _nomeController),
        SettingsTextField(
          label: 'Bio / Descrição',
          controller: _descricaoController,
          maxLines: 4,
        ),

        // --- CAMPOS ESPECÍFICOS: JOGADOR ---
        if (tipo == 'jogador') ...[
          const Divider(height: 32),
          const Text(
            'Dados do Atleta',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SettingsTextField(
                  label: 'Altura (m)',
                  controller: _alturaController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SettingsTextField(
                  label: 'Peso (kg)',
                  controller: _pesoController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SettingsTextField(
            label: 'Data de Nascimento',
            controller: _dataNascController,
            keyboardType: TextInputType.datetime,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: DropdownButtonFormField<String>(
              initialValue: _selectedPosition,
              decoration: InputDecoration(
                labelText: 'Posição',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _positions
                  .map((pos) => DropdownMenuItem(value: pos, child: Text(pos)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedPosition = value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: DropdownButtonFormField<String>(
              initialValue: _selectedPreferredFoot,
              decoration: InputDecoration(
                labelText: 'Perna Preferida',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _preferredFeet
                  .map((pe) => DropdownMenuItem(value: pe, child: Text(pe)))
                  .toList(),
              onChanged: (value) =>
                  setState(() => _selectedPreferredFoot = value),
            ),
          ),
        ],

        // --- CAMPOS ESPECÍFICOS: OLHEIRO ---
        if (tipo == 'olheiro') ...[
          const Divider(height: 32),
          const Text(
            'Dados Profissionais',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          SettingsTextField(
            label: 'Clube Representante',
            controller: _clubeRepresentanteController,
          ),
        ],

        // --- CAMPOS ESPECÍFICOS: JOGADOR E CLUBE ---
        if (tipo == 'jogador' || tipo == 'clube') ...[
          SettingsTextField(
            label: 'Cidade base',
            controller: _cidadeController,
          ),
        ],

        // --- CAMPOS ESPECÍFICOS: OLHEIRO E CLUBE ---
        if (tipo == 'olheiro' || tipo == 'clube') ...[
          SettingsTextField(
            label: 'Que tipo de jogadores você procura?',
            controller: _jogadoresProcuradosController,
            maxLines: 3,
          ),
        ],

        // --- REDES SOCIAIS (Todos) ---
        const Divider(height: 32),
        const Text(
          'Redes Sociais (Até 3 links)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        SettingsTextField(
          label: 'Link 1 (Ex: instagram.com/...)',
          controller: _link1Controller,
        ),
        SettingsTextField(
          label: 'Link 2 (Ex: youtube.com/...)',
          controller: _link2Controller,
        ),
        SettingsTextField(label: 'Link 3', controller: _link3Controller),

        const SizedBox(height: 24),

        // --- BOTÃO SALVAR ---
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isSalving ? null : _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF195E3B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isSalving ? 'Salvando...' : 'Salvar Alterações',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
