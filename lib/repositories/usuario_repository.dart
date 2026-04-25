import 'package:firebase_auth/firebase_auth.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/services/auth_service.dart';
import 'package:goalink/services/cache_service.dart';
import 'package:goalink/services/storage_service.dart';
import 'package:goalink/services/usuario_service.dart';

class UsuarioRepository {
  final UsuarioService _usuarioService;
  final AuthService _authService;
  final CacheService _cacheService;

  UsuarioRepository(
    this._authService,
    this._usuarioService,
    this._cacheService,
  );

  Future<void> cadastrarUsuario(
    UsuarioModel usuario,
    String senha, [
    String? fotoLocalPath,
    StorageService? storageService,
  ]) async {
    User? response = await _authService.criarInstanciaUsuario(
      usuario.email,
      senha,
    );
    if (response != null) {
      String? fotoUrl;
      if (fotoLocalPath != null && storageService != null) {
        fotoUrl = await storageService.uploadFotoPerfil(
          uid: response.uid,
          caminhoLocal: fotoLocalPath,
        );
      }

      final usuarioInstancia = usuario.copyWith(
        id: response.uid,
        fotoUrl: fotoUrl,
      );
      await _usuarioService.cadastrarUsuarioNoBanco(usuarioInstancia);
    }
  }

  Future<void> fazerLogin(String email, String senha) async {
    User? usuarioAuth = await _authService.login(email, senha);
    if (usuarioAuth != null) {
      UsuarioModel? usuario = await _authService.obterUsuarioUid(
        usuarioAuth.uid,
      );
      if (usuario != null) {
        await _cacheService.salvarPerfilLocal(usuario);
      } else {
        throw Exception('Usuário não encontrado no banco de dados.');
      }
    }
  }

  Future<List<UsuarioModel>> obterJogadoresNovos() async {
    return await _usuarioService.obterJogadoresNovos();
  }
}
