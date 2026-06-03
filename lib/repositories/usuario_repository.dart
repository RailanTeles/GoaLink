import 'package:firebase_auth/firebase_auth.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/services/auth_service.dart';
import 'package:goalink/services/avaliacao_service.dart';
import 'package:goalink/services/cache_service.dart';
import 'package:goalink/services/chat_mensagem_service.dart';
import 'package:goalink/services/favorito_service.dart';
import 'package:goalink/services/notificacao_service.dart';
import 'package:goalink/services/postagem_service.dart';
import 'package:goalink/services/storage_service.dart';
import 'package:goalink/services/usuario_service.dart';

class UsuarioRepository {
  final UsuarioService _usuarioService;
  final PostagemService _postagemService;
  final AuthService _authService;
  final CacheService _cacheService;
  final StorageService _storageService;
  final AvaliacaoService _avaliacaoService;
  final ChatMensagemService _chatMensagemService;
  final FavoritoService _favoritoService;
  final NotificacaoService _notificacaoService;

  UsuarioRepository(
    this._authService,
    this._postagemService,
    this._usuarioService,
    this._cacheService,
    this._storageService,
    this._avaliacaoService,
    this._chatMensagemService,
    this._favoritoService,
    this._notificacaoService,
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

  Future<void> deletarConta(String senha, String uid, String? fotoUrl) async {
    await _authService.verificarSenha(senha);
    // Deletar postagens do usuário
    List<String> urlsMidiasPostagens = await _postagemService
        .deletarPostagensUsuario(uid);
    if (urlsMidiasPostagens.isNotEmpty) {
      await Future.wait(
        urlsMidiasPostagens.map((url) => _storageService.deletarMidia(url)),
      );
    }

    // Deleta as avaliações feitas pelo usuário e para o usuário
    await _avaliacaoService.deletarAvaliacoesUsuario(uid);

    // Deleta os favoritos do usuário e para o usuário
    await _favoritoService.deletarFavoritosUsuario(uid);

    // Deleta as notificações do usuário
    await _notificacaoService.deletarNotificacoesUsuario(uid);

    // Anonimiza os dados do usuário e para o usuário nos chats
    await _chatMensagemService.softDeletarMensagensChat(uid);

    // Deleta a foto do usuário
    if (fotoUrl != null) await _storageService.deletarMidia(fotoUrl);

    // Deleta o usuário no banco de dados
    await _usuarioService.deletarUsuario(uid);

    // Limpa o cache e desloga do usuário
    await _cacheService.limparCachePerfilLogado();
    await _authService.deletarConta();
    await _authService.logout();
  }

  Future<void> alterarSenha(String senhaAntiga, String senhaNova) async {
    await _authService.alterarSenha(senhaAntiga, senhaNova);
  }

  Future<UsuarioModel> obterUsuarioLogado() async {
    var usuarioLogado = await _cacheService.buscarPerfilLocal();
    if (usuarioLogado != null &&
        usuarioLogado.id == FirebaseAuth.instance.currentUser?.uid) {
      return usuarioLogado;
    }

    var usuario = await _usuarioService.obterUsuarioUid(
      FirebaseAuth.instance.currentUser!.uid,
    );

    if (usuario != null) {
      await _cacheService.salvarPerfilLocal(usuario);
      return usuario;
    }

    throw Exception('Usuário não encontrado no banco de dados.');
  }

  Future<void> recuperarSenha(String email) async {
    await _authService.recuperarSenha(email.trim());
  }

  Future<void> atualizarUsuario(
    UsuarioModel usuario,
    String? fotoLocalPath,
    bool removerFoto,
  ) async {
    if (removerFoto) {
      await _storageService.deletarMidia(usuario.fotoUrl!);
      usuario = usuario.copyWith(fotoUrl: null);
    }

    if (fotoLocalPath != null && !removerFoto) {
      String? fotoUrl = await _storageService.editarFotoPerfil(
        uid: usuario.id,
        caminhoLocal: fotoLocalPath,
      );
      usuario = usuario.copyWith(fotoUrl: fotoUrl);
    }

    await _usuarioService.atualizarUsuario(usuario);

    await _cacheService.salvarPerfilLocal(usuario);

    await _postagemService.sincronizarDadosDoAutor(
      usuario.id,
      usuario.nome,
      usuario.fotoUrl,
    );
  }

  Future<void> fazerLogin(String email, String senha) async {
    User? usuarioAuth = await _authService.login(email, senha);
    if (usuarioAuth != null) {
      UsuarioModel? usuario = await _usuarioService.obterUsuarioUid(
        usuarioAuth.uid,
      );
      if (usuario != null) {
        await _cacheService.salvarPerfilLocal(usuario);
      } else {
        throw Exception('Usuário não encontrado no banco de dados.');
      }
    }
  }

  Future<void> fazerLogout() async {
    await _cacheService.limparCachePerfilLogado();
    await _cacheService.limparCachePostagens();
    await _authService.logout();
  }

  Future<List<UsuarioModel>> obterJogadoresNovos() async {
    return await _usuarioService.obterJogadoresNovos();
  }
}
