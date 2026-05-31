import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/core/circular_loading.dart';
import 'package:goalink/screens/settings/settings_view_model.dart';
import 'package:goalink/screens/settings/widgets/change_password_form.dart';
import 'package:goalink/screens/settings/widgets/delete_account_form.dart';
// import 'package:goalink/screens/settings/widgets/delete_account_form.dart';
import 'package:goalink/screens/settings/widgets/edit_profile_form.dart';
// import 'package:goalink/screens/settings/widgets/notifications_form.dart';
import 'package:goalink/screens/settings/widgets/settings_expansion_tile.dart';
import 'package:goalink/screens/settings/widgets/settings_primary_button.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _obterUsuario();
      context.read<SettingsViewModel>().addListener(_onViewModelChange);
    });
  }

  Future<void> _obterUsuario() async {
    await context.read<SettingsViewModel>().obterUsuario();
  }

  void _onViewModelChange() {
    final vm = context.read<SettingsViewModel>();
    if (vm.erroSnackBar != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.erroSnackBar!), backgroundColor: Colors.red),
      );
    }
    if (vm.sucessoSnackBar != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.sucessoSnackBar!),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsViewModel>();

    if (vm.isLoading) {
      return const Scaffold(body: CircularLoading());
    }

    if (vm.erro != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ops!'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Colors.white,
        ),
        body: RefreshIndicator(
          onRefresh: () async => _obterUsuario(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_off_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 64,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        vm.erro!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF6),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Configurações', style: TextStyle(fontWeight: .w700)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }

            context.go('/');
          },
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
          child: Column(
            children: [
              SettingsExpansionTile(
                title: 'Conta',
                leadingIcon: Icons.person,
                initiallyExpanded: true,
                children: [
                  SettingsExpansionTile(
                    title: 'Editar Perfil',
                    leadingIcon: Icons.edit_outlined,
                    isSubItem: true,
                    children: [EditProfileForm(usuario: vm.usuario!)],
                  ),
                  SettingsExpansionTile(
                    title: 'Alterar Senha',
                    leadingIcon: Icons.lock_outline,
                    isSubItem: true,
                    children: [ChangePasswordForm()],
                  ),
                  SettingsExpansionTile(
                    title: 'Excluir Conta',
                    leadingIcon: Icons.delete_outline,
                    isSubItem: true,
                    children: [DeleteAccountForm()],
                  ),
                  SettingsPrimaryButton(
                    label: 'Sair da conta',
                    backgroundColor: Color(0xFFD32F2F),
                    onPressed: () async {
                      final sucesso = await context
                          .read<SettingsViewModel>()
                          .sair();
                      if (sucesso && context.mounted) {
                        context.go('/login');
                      } else if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.read<SettingsViewModel>().erroSnackBar!,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 14),
              // SettingsExpansionTile(
              //   title: 'Notificações',
              //   leadingIcon: Icons.notifications_none,
              //   children: [NotificationsForm()],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
