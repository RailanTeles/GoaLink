import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/repositories/usuario_repository.dart';
import 'package:goalink/services/cache_service.dart';

class AuthProvider extends ChangeNotifier {
  final UsuarioRepository _usuarioRepository;
  final CacheService _cacheService;

  User? _firebaseUser;
  UsuarioModel? _usuario;
  bool _isLoading = false;
  String? _error;

  User? get firebaseUser => _firebaseUser;
  UsuarioModel? get usuario => _usuario;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _firebaseUser != null && _usuario != null;

  late final StreamSubscription<User?> _authSubscription;

  AuthProvider(this._usuarioRepository, this._cacheService) {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    // Carrega o estado inicial
    _firebaseUser = FirebaseAuth.instance.currentUser;
    if (_firebaseUser != null) {
      await _loadUsuario();
    }

    _isLoading = false;
    notifyListeners();

    // Escuta mudanças de autenticação e notifica apenas quando tudo estiver pronto
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _firebaseUser = user;
    
    if (user != null) {
      await _loadUsuario();
    } else {
      _usuario = null;
      await _cacheService.limparCachePerfilLogado();
      await _cacheService.limparCachePostagens();
    }
    
    notifyListeners();
  }

  Future<void> _loadUsuario() async {
    try {
      // Tenta carregar do cache primeiro
      _usuario = await _cacheService.buscarPerfilLocal();
      
      // Se não tem no cache ou o ID não confere, carrega do banco
      if (_usuario == null || _usuario!.id != _firebaseUser!.uid) {
        _usuario = await _usuarioRepository.obterUsuarioLogado();
      }
    } catch (e) {
      _error = e.toString();
      _usuario = null;
    }
  }

  Future<bool> login(String email, String senha) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _usuarioRepository.fazerLogin(email, senha);
      // Não precisa chamar notifyListeners() aqui porque o _onAuthStateChanged já vai chamar
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _usuarioRepository.fazerLogout();
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> refreshUsuario() async {
    if (_firebaseUser != null) {
      await _loadUsuario();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
