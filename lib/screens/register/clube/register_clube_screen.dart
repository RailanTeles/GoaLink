import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:goalink/screens/register/clube/register_clube_view_model.dart';
import 'package:goalink/screens/register/widgets/register_background.dart';
import 'package:goalink/screens/register/widgets/register_form_panel.dart';
import 'package:goalink/screens/register/widgets/register_header.dart';
import 'package:goalink/screens/register/widgets/register_input_field.dart';
import 'package:goalink/screens/register/widgets/register_photo_picker_button.dart';
import 'package:goalink/screens/register/widgets/register_primary_button.dart';

class RegisterClubeScreen extends StatefulWidget {
  const RegisterClubeScreen({super.key});

  @override
  State<RegisterClubeScreen> createState() => _RegisterClubeScreenState();
}

class _RegisterClubeScreenState extends State<RegisterClubeScreen> {
  final _nomeClubeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _jogadoresController = TextEditingController();

  bool _showSenha = false;
  bool _showConfirmarSenha = false;

  @override
  void dispose() {
    _nomeClubeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _cidadeController.dispose();
    _descricaoController.dispose();
    _jogadoresController.dispose();
    super.dispose();
  }

  Future<void> _selecionarFoto() async {
    final vm = context.read<RegisterClubeViewModel>();
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) vm.setFotoPerfil(picked);
  }

  Future<void> _handleCadastro() async {
    final vm = context.read<RegisterClubeViewModel>();
    final erro = await vm.cadastrar(
      nomeClube: _nomeClubeController.text,
      email: _emailController.text,
      senha: _senhaController.text,
      confirmarSenha: _confirmarSenhaController.text,
      cidade: _cidadeController.text,
      descricao: _descricaoController.text,
      jogadoresProcurados: _jogadoresController.text,
    );

    if (!mounted) return;
    if (erro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cadastro realizado com sucesso!'),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      context.go('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erro),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (RegisterClubeViewModel vm) => vm.isLoading,
    );
    final fotoPerfil = context.select(
      (RegisterClubeViewModel vm) => vm.fotoPerfil,
    );

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RegisterHeader(
                        title: 'Clube',
                        topSpacing: 20,
                        iconSize: 110,
                        onBack: () => context.go('/cadastro/funcao'),
                      ),
                      const SizedBox(height: 32),

                      RegisterFormPanel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionTitle('Acesso'),
                            const SizedBox(height: 18),
                            RegisterInputField(
                              label: 'Nome do Clube',
                              controller: _nomeClubeController,
                            ),
                            const SizedBox(height: 22),
                            RegisterInputField(
                              label: 'E-mail',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 22),
                            RegisterInputField(
                              label: 'Senha',
                              controller: _senhaController,
                              obscureText: !_showSenha,
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    setState(() => _showSenha = !_showSenha),
                                icon: Icon(
                                  _showSenha
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            RegisterInputField(
                              label: 'Confirmar Senha',
                              controller: _confirmarSenhaController,
                              obscureText: !_showConfirmarSenha,
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                  () => _showConfirmarSenha =
                                      !_showConfirmarSenha,
                                ),
                                icon: Icon(
                                  _showConfirmarSenha
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      RegisterFormPanel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionTitle('Detalhes'),
                            const SizedBox(height: 18),
                            RegisterInputField(
                              label: 'Cidade',
                              controller: _cidadeController,
                            ),
                            const SizedBox(height: 22),
                            RegisterInputField(
                              label: 'Descrição',
                              controller: _descricaoController,
                              maxLines: 4,
                              minLines: 4,
                            ),
                            const SizedBox(height: 22),
                            RegisterInputField(
                              label: 'Jogadores que procura',
                              controller: _jogadoresController,
                              maxLines: 3,
                              minLines: 3,
                            ),
                            const SizedBox(height: 22),
                            RegisterPhotoPickerButton(
                              nomeArquivo: fotoPerfil?.name,
                              onTap: _selecionarFoto,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      RegisterPrimaryButton(
                        label: isLoading ? 'Criando conta...' : 'Criar Conta',
                        onPressed: isLoading ? null : _handleCadastro,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}
