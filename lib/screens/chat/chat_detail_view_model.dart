import 'dart:async';

import 'package:flutter/material.dart';
import 'package:goalink/models/chat_model.dart';
import 'package:goalink/models/messagem_model.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/repositories/chat_mensagem_repository.dart';
import 'package:goalink/repositories/usuario_repository.dart';

class ChatDetailViewModel extends ChangeNotifier {
  final ChatMensagemRepository _mensagemRepository;
  final UsuarioRepository _usuarioRepository;

  ChatDetailViewModel(this._mensagemRepository, this._usuarioRepository);

  String? _chatId;
  UsuarioModel? _meuUsuario;
  UsuarioModel? _outroUsuario;
  ChatModel? _chatAtualSnapshot;

  Stream<ChatModel?>? _chatAtualStream;
  Stream<List<MensagemModel>>? _mensagensStream;

  bool _isEnviandoMensagem = false;
  String? _erroSnackBar;
  Timer? _debounce;
  StreamSubscription? _chatSub;

  String? get chatId => _chatId;
  UsuarioModel? get meuUsuario => _meuUsuario;
  UsuarioModel? get outroUsuario => _outroUsuario;
  Stream<ChatModel?>? get chatAtualStream => _chatAtualStream;
  Stream<List<MensagemModel>>? get mensagensStream => _mensagensStream;
  bool get isEnviandoMensagem => _isEnviandoMensagem;
  String? get erroSnackBar => _erroSnackBar;

  @override
  void dispose() {
    _debounce?.cancel();
    _chatSub?.cancel();
    super.dispose();
  }

  Future<void> obterInformacoesInicias(
    String chatId,
    UsuarioModel? outroUsuario,
  ) async {
    _meuUsuario = await _usuarioRepository.obterUsuarioLogado();
    _chatId = chatId;
    if (outroUsuario != null) {
      _outroUsuario = outroUsuario;
    }

    _ouvirDetalhes();
    _obterMensagens();
  }

  void _ouvirDetalhes() {
    if (_chatId == null) return;

    _chatAtualStream = _mensagemRepository.ouvirDetalhesChat(_chatId!);

    _chatSub = _chatAtualStream!.listen((chat) async {
      _chatAtualSnapshot = chat;

      if (chat != null && _outroUsuario == null && _meuUsuario != null) {
        final outroUid = chat.participantes.firstWhere(
          (id) => id != _meuUsuario!.id,
        );
        _outroUsuario = await _usuarioRepository.obterUsuarioPorUid(outroUid);
        notifyListeners();
      }

      if (chat != null && _meuUsuario != null && _outroUsuario != null) {
        final naoLidas = chat.mensagensNaoLidas[_meuUsuario!.id] ?? 0;
        if (naoLidas > 0) {
          marcarMensagensComoLidas();
        }
      }
    });
  }

  void _obterMensagens() {
    if (_chatId == null) return;
    _mensagensStream = _mensagemRepository.ouvirMensagens(_chatId!);
    notifyListeners();
  }

  Future<void> marcarMensagensComoLidas() async {
    if (_chatId == null || _meuUsuario == null || _outroUsuario == null) return;
    await _mensagemRepository.marcarMensagensComoLidas(
      _chatId!,
      _meuUsuario!.id,
      _outroUsuario!.id,
    );
  }

  Future<void> atualizarDigitando(bool isTyping) async {
    if (_chatId == null || _meuUsuario == null) return;

    _debounce?.cancel();

    await _mensagemRepository.atualizarEstadoDigitando(
      _chatId!,
      _meuUsuario!.id,
      isTyping,
    );

    if (isTyping) {
      _debounce = Timer(const Duration(milliseconds: 800), () async {
        await _mensagemRepository.atualizarEstadoDigitando(
          _chatId!,
          _meuUsuario!.id,
          false,
        );
      });
    }
  }

  Future<bool> enviarMensagem(String texto) async {
    if (texto.trim().isEmpty ||
        _chatId == null ||
        _meuUsuario == null ||
        _outroUsuario == null) {
      return false;
    }

    _erroSnackBar = null;
    _isEnviandoMensagem = true;
    notifyListeners();

    try {
      ChatModel chatParaEnvio =
          _chatAtualSnapshot ??
          ChatModel(
            idChat: _chatId!,
            participantes: [_meuUsuario!.id, _outroUsuario!.id],
            ultimaMensagem: '',
            atualizadoEm: DateTime.now(),
            usuarioDados: {
              _meuUsuario!.id: {
                'nome': _meuUsuario!.nome,
                'foto_perfil': _meuUsuario!.fotoUrl,
                'tipo': 'jogador',
              },
              _outroUsuario!.id: {
                'nome': _outroUsuario!.nome,
                'foto_perfil': _outroUsuario!.fotoUrl,
                'tipo': 'jogador',
              },
            },
            digitando: {_meuUsuario!.id: false, _outroUsuario!.id: false},
            mensagensNaoLidas: {_meuUsuario!.id: 0, _outroUsuario!.id: 0},
          );

      await _mensagemRepository.enviarMensagem(
        chatParaEnvio,
        _meuUsuario!.id,
        _outroUsuario!.id,
        texto.trim(),
      );
      return true;
    } catch (e) {
      _erroSnackBar = e.toString().replaceAll('Exception: ', '');
      debugPrint('Erro ao enviar: $e');
      return false;
    } finally {
      _isEnviandoMensagem = false;
      notifyListeners();
    }
  }
}
