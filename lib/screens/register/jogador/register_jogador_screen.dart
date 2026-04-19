import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:goalink/core/date_input_formatter.dart';
import 'package:goalink/screens/register/jogador/register_jogador_view_model.dart';
import 'package:goalink/screens/register/widgets/register_background.dart';
import 'package:goalink/screens/register/widgets/register_form_panel.dart';
import 'package:goalink/screens/register/widgets/register_header.dart';
import 'package:goalink/screens/register/widgets/register_input_field.dart';
import 'package:goalink/screens/register/widgets/register_photo_picker_button.dart';
import 'package:goalink/screens/register/widgets/register_primary_button.dart';

class RegisterJogadorScreen extends StatefulWidget {
  const RegisterJogadorScreen({super.key});

  @override
  State<RegisterJogadorScreen> createState() => _RegisterJogadorScreenState();
}

class _RegisterJogadorScreenState extends State<RegisterJogadorScreen> {
  // ── Controllers ──────────────────────────────────────────────────────────────
  final _emailController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _nomeController = TextEditingController();
  final _alturaController = TextEditingController();
  final _pesoController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _posicaoController = TextEditingController();
  final _pernaPreferidaController = TextEditingController();
  final _descricaoController = TextEditingController();

  // ── Estados locais ──────────────────────────────────────────────────────────
  bool _showSenha = false;
  bool _showConfirmarSenha = false;

  @override
  void dispose() {
    _emailController.dispose();
    _dataNascimentoController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _nomeController.dispose();
    _alturaController.dispose();
    _pesoController.dispose();
    _cidadeController.dispose();
    _posicaoController.dispose();
    _pernaPreferidaController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  // ── Bottom sheets ────────────────────────────────────────────────────────────
  Future<void> _selecionarPosicao() async {
    final selected = await _showPickerSheet(
      context,
      opcoes: RegisterJogadorViewModel.posicoes,
      selecionado: _posicaoController.text,
    );
    if (selected != null) setState(() => _posicaoController.text = selected);
  }

  Future<void> _selecionarPerna() async {
    final selected = await _showPickerSheet(
      context,
      opcoes: RegisterJogadorViewModel.pernasPreferidas,
      selecionado: _pernaPreferidaController.text,
    );
    if (selected != null) {
      setState(() => _pernaPreferidaController.text = selected);
    }
  }

  Future<String?> _showPickerSheet(
    BuildContext context, {
    required List<String> opcoes,
    required String selecionado,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF101010),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: opcoes.length,
          separatorBuilder: (_, index) =>
              Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          itemBuilder: (ctx, i) {
            final opcao = opcoes[i];
            return ListTile(
              title: Text(opcao, style: const TextStyle(color: Colors.white)),
              trailing: selecionado == opcao
                  ? Icon(
                      Icons.check_rounded,
                      color: Theme.of(ctx).colorScheme.primary,
                    )
                  : null,
              onTap: () => Navigator.of(ctx).pop(opcao),
            );
          },
        ),
      ),
    );
  }

  // ── Foto de perfil ───────────────────────────────────────────────────────────
  Future<void> _selecionarFoto() async {
    final vm = context.read<RegisterJogadorViewModel>();
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) vm.setFotoPerfil(picked);
  }

  Future<void> _handleCadastro() async {
    final vm = context.read<RegisterJogadorViewModel>();
    final erro = await vm.cadastrar(
      email: _emailController.text,
      dataNascimento: _dataNascimentoController.text,
      senha: _senhaController.text,
      confirmarSenha: _confirmarSenhaController.text,
      nome: _nomeController.text,
      altura: _alturaController.text,
      peso: _pesoController.text,
      cidade: _cidadeController.text,
      posicao: _posicaoController.text,
      pernaPreferida: _pernaPreferidaController.text,
      descricao: _descricaoController.text,
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

  // ── Build ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (RegisterJogadorViewModel vm) => vm.isLoading,
    );
    final fotoPerfil = context.select(
      (RegisterJogadorViewModel vm) => vm.fotoPerfil,
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
                    crossAxisAlignment: .start,
                    children: [
                      // ── Header ─────────────────────────────────────────────
                      RegisterHeader(
                        title: 'Jogador',
                        topSpacing: 20,
                        iconSize: 110,
                        onBack: () => context.go('/cadastro/funcao'),
                      ),
                      const SizedBox(height: 32),

                      // ── Seção 1: Acesso ────────────────────────────────────
                      RegisterFormPanel(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            _sectionTitle('Acesso'),
                            const SizedBox(height: 18),
                            RegisterInputField(
                              label: 'Email',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 22),
                            RegisterInputField(
                              label: 'Data de Nascimento',
                              controller: _dataNascimentoController,
                              hintText: 'DD/MM/AAAA',
                              keyboardType: TextInputType.datetime,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                DateInputFormatter(),
                              ],
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

                      // ── Seção 2: Perfil ────────────────────────────────────
                      RegisterFormPanel(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            _sectionTitle('Perfil'),
                            const SizedBox(height: 18),
                            RegisterInputField(
                              label: 'Nome',
                              controller: _nomeController,
                            ),
                            const SizedBox(height: 22),
                            Row(
                              children: [
                                Expanded(
                                  child: RegisterInputField(
                                    label: 'Altura',
                                    controller: _alturaController,
                                    hintText: 'ex: 1,80',
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9.,]'),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: RegisterInputField(
                                    label: 'Peso',
                                    controller: _pesoController,
                                    hintText: 'ex: 75',
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9.,]'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 22),
                            RegisterInputField(
                              label: 'Cidade',
                              controller: _cidadeController,
                            ),
                            const SizedBox(height: 22),
                            RegisterInputField(
                              label: 'Posição em campo',
                              controller: _posicaoController,
                              readOnly: true,
                              onTap: _selecionarPosicao,
                              hintText: 'Selecione uma posição',
                              suffixIcon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Seção 3: Detalhes ──────────────────────────────────
                      RegisterFormPanel(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            _sectionTitle('Detalhes'),
                            const SizedBox(height: 18),
                            RegisterInputField(
                              label: 'Perna Preferida',
                              controller: _pernaPreferidaController,
                              readOnly: true,
                              onTap: _selecionarPerna,
                              hintText: 'Selecione uma opção',
                              suffixIcon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 22),
                            RegisterInputField(
                              label: 'Breve descrição sobre você',
                              controller: _descricaoController,
                              maxLines: 4,
                              minLines: 4,
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

                      // ── Botão submit ──────────────────────────────────────
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
