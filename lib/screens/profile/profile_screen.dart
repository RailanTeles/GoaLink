import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/screens/profile/widgets/change_password_form.dart';
import 'package:goalink/screens/profile/widgets/delete_account_form.dart';
import 'package:goalink/screens/profile/widgets/edit_profile_form.dart';
import 'package:goalink/screens/profile/widgets/notifications_form.dart';
import 'package:goalink/screens/profile/widgets/settings_expansion_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color _darkGreen = Color(0xFF195E3B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF6),
      appBar: AppBar(
        backgroundColor: _darkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Configurações',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
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
            children: const [
              SettingsExpansionTile(
                title: 'Conta',
                leadingIcon: Icons.person,
                initiallyExpanded: true,
                children: [
                  SettingsExpansionTile(
                    title: 'Editar Perfil',
                    leadingIcon: Icons.edit_outlined,
                    isSubItem: true,
                    children: [EditProfileForm()],
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
                ],
              ),
              SizedBox(height: 14),
              SettingsExpansionTile(
                title: 'Notificações',
                leadingIcon: Icons.notifications_none,
                children: [NotificationsForm()],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
