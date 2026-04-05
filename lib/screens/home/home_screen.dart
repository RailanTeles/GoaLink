import 'package:flutter/material.dart';
import 'package:goalink/core/circular_loading.dart';
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
  Map<String, UsuarioModel> usuariosPorId = {};

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDadosIniciais();
  }

  Future<void> _carregarDadosIniciais() async {
    try {
      final resultados = await Future.wait([
        _usuarioService.getJogadoresNovos(),
        _postagemService.getFeedPostagens(),
        _usuarioService.getJogadores(),
      ]);

      final usuarios = resultados[0] as List<UsuarioModel>;
      final postagens = resultados[1] as List<PostagemModel>;
      final jogadores = resultados[2] as List<UsuarioModel>;
      final mapaUsuarios = {
        for (final jogador in jogadores) jogador.id: jogador,
      };

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          listaJogadoresNovos = usuarios;
          listaPostagens = postagens;
          usuariosPorId = mapaUsuarios;
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
      return const CircularLoading();
    }
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _carregarDadosIniciais,
        color: Theme.of(context).colorScheme.secondary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: NovosJogadoresWidget(
                  listaJogadores: listaJogadoresNovos,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: PostagensWidget(
                listaPostagens: listaPostagens,
                usuariosPorId: usuariosPorId,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }
}
