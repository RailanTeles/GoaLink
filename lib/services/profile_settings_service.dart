import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:goalink/models/notification_preferences_model.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSettingsService {
  ProfileSettingsService._();

  static final ProfileSettingsService instance = ProfileSettingsService._();

  static const String _profileKey = 'profile_settings.current_user';
  static const String _notificationKey = 'profile_settings.notifications';
  static const String _passwordKey = 'profile_settings.password';
  static const String _defaultPassword = '123456';

  Future<UsuarioModel> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final savedProfile = prefs.getString(_profileKey);

    if (savedProfile != null && savedProfile.isNotEmpty) {
      return UsuarioModel.fromJson(
        json.decode(savedProfile) as Map<String, dynamic>,
      );
    }

    final profile = await _loadDefaultProfile();
    await prefs.setString(_profileKey, json.encode(profile.toJson()));
    return profile;
  }

  Future<void> saveProfile(UsuarioModel profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, json.encode(profile.toJson()));
  }

  Future<NotificationPreferencesModel> getNotificationPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSettings = prefs.getString(_notificationKey);

    if (savedSettings != null && savedSettings.isNotEmpty) {
      return NotificationPreferencesModel.fromJson(
        json.decode(savedSettings) as Map<String, dynamic>,
      );
    }

    const defaults = NotificationPreferencesModel(
      interesseClubes: true,
      mensagens: true,
      atualizacoes: false,
    );

    await prefs.setString(_notificationKey, json.encode(defaults.toJson()));
    return defaults;
  }

  Future<void> saveNotificationPreferences(
    NotificationPreferencesModel settings,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notificationKey, json.encode(settings.toJson()));
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final currentPassword = prefs.getString(_passwordKey) ?? _defaultPassword;

    if (oldPassword != currentPassword) {
      return false;
    }

    await prefs.setString(_passwordKey, newPassword);
    return true;
  }

  Future<UsuarioModel> _loadDefaultProfile() async {
    final response = await rootBundle.loadString('assets/mocks/usuarios.json');
    final data = json.decode(response) as List<dynamic>;

    final jogadores = data
        .map((json) => UsuarioModel.fromJson(json as Map<String, dynamic>))
        .where((user) => user.tipo == 'jogador')
        .toList();

    if (jogadores.isNotEmpty) {
      return jogadores.first;
    }

    return UsuarioModel(
      id: 'local-user',
      tipo: 'jogador',
      nome: '',
      criadoEm: DateTime.now(),
    );
  }
}
