import 'package:flutter/material.dart';
import 'package:goalink/models/postagem_model.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/screens/home/widgets/novos_jogadores_widget.dart';
import 'package:goalink/screens/home/widgets/postagens_widget.dart';
import 'package:goalink/services/postagem_service.dart';
import 'package:goalink/services/usuario_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UsuarioService _usuarioService = UsuarioService();
  final PostagemService _postagemService = PostagemService();
  List<UsuarioModel> listaJogadoresNovos = [];
  List<PostagemModel> listaPostagens = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDadosIniciais();
  }

  Future<void> _carregarDadosIniciais() async {
    try {
      final usuarios = await _usuarioService.getJogadoresNovos();
      final postagens = await _postagemService.getFeedPostagens();

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          listaJogadoresNovos = usuarios;
          listaPostagens = postagens;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
            strokeWidth: 4.0,
          ),
        ),
      );
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: NovosJogadoresWidget(listaJogadores: listaJogadoresNovos),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: PostagensWidget(listaPostagens: listaPostagens),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}
