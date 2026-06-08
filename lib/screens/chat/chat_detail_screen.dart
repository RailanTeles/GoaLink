import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goalink/models/messagem_model.dart';
import 'package:goalink/screens/chat/chat_detail_view_model.dart';
import 'package:goalink/screens/chat/widget/message_bubble.dart';
import 'package:goalink/screens/chat/widget/typing_indicator.dart';
import 'package:provider/provider.dart';
import 'package:goalink/models/chat_model.dart';
import 'package:goalink/models/usuario_model.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  final UsuarioModel? outroUsuario;

  const ChatDetailScreen({super.key, required this.chatId, this.outroUsuario});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatDetailViewModel>().obterInformacoesInicias(
        widget.chatId,
        widget.outroUsuario,
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSendMessage(ChatDetailViewModel vm) async {
    final texto = _messageController.text;
    if (texto.trim().isEmpty) return;

    final sucesso = await vm.enviarMensagem(texto);
    if (sucesso) {
      _messageController.clear();
    } else if (vm.erroSnackBar != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.erroSnackBar!), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ChatDetailViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: vm.outroUsuario == null
            ? const Text('Carregando...', style: TextStyle(fontSize: 16))
            : Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    backgroundImage: vm.outroUsuario!.fotoUrl != null
                        ? NetworkImage(vm.outroUsuario!.fotoUrl!)
                        : null,
                    child: vm.outroUsuario!.fotoUrl == null
                        ? Text(
                            vm.outroUsuario!.nome.isNotEmpty
                                ? vm.outroUsuario!.nome[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      vm.outroUsuario!.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Lista de Mensagens
            Expanded(
              child: StreamBuilder<List<MensagemModel>>(
                stream: vm.mensagensStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar mensagens.'),
                    );
                  }

                  final mensagens = snapshot.data ?? [];

                  // Inverte a lista para o estilo WhatsApp (mais recentes embaixo)
                  final mensagensReversas = mensagens.reversed.toList();

                  return ListView.builder(
                    reverse: true, // Mantém o scroll ancorado embaixo
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                    itemCount: mensagensReversas.length,
                    itemBuilder: (context, index) {
                      final msg = mensagensReversas[index];
                      final isMe = msg.remetenteId == vm.meuUsuario?.id;

                      return MessageBubble(mensagem: msg, isMe: isMe);
                    },
                  );
                },
              ),
            ),

            // O Indicador de "Digitando..." (Reativo ao Stream do Chat Atual)
            if (vm.outroUsuario != null)
              StreamBuilder<ChatModel?>(
                stream: vm.chatAtualStream,
                builder: (context, snapshot) {
                  final chatAtual = snapshot.data;
                  final outroDigitando =
                      chatAtual?.digitando[vm.outroUsuario!.id] ?? false;

                  if (outroDigitando) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: const TypingIndicator(),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

            // Área de Input
            Container(
              color: Colors.grey.shade400,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textInputAction: TextInputAction.send,
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                          vm.atualizarDigitando(true);
                        }
                      },
                      onSubmitted: (_) => _handleSendMessage(vm),
                      decoration: InputDecoration(
                        hintText: 'Digite sua mensagem...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: const CircleBorder(),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: vm.isEnviandoMensagem
                          ? null
                          : () => _handleSendMessage(vm),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: vm.isEnviandoMensagem
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 20,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
