import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/services/interacao_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _interacaoService = InteracaoService();
  late Future<List<UsuarioModel>> _favoritosFuture;
  final Set<String> _desmarcados = {};

  @override
  void initState() {
    super.initState();
    _favoritosFuture = _interacaoService.getUsuariosFavoritados('clube_01');
  }

  void _toggleFavorito(String idUsuario) {
    setState(() {
      if (_desmarcados.contains(idUsuario)) {
        _desmarcados.remove(idUsuario);
        // TODO: chamar backend para favoritar
      } else {
        _desmarcados.add(idUsuario);
        // TODO: chamar backend para desfavoritar
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Favoritos', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<UsuarioModel>>(
                future: _favoritosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar favoritos.'),
                    );
                  }

                  final favoritos = snapshot.data ?? [];

                  if (favoritos.isEmpty) {
                    return const Center(
                      child: Text('Sem favoritos no momento.'),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 90),
                    itemCount: favoritos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) =>
                        _buildFavoritoItem(favoritos[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritoItem(UsuarioModel usuario) {
    final tipo = usuario.tipo[0].toUpperCase() + usuario.tipo.substring(1);
    final marcado = !_desmarcados.contains(usuario.id);
    final icone = marcado
        ? 'assets/images/icons/favorito_estrela.svg'
        : 'assets/images/icons/favorito_estrela_desmarcada.svg';

    return GestureDetector(
      // TODO: descomentar quando a rota de perfil do jogador estiver pronta
      // onTap: () => context.push('/jogador/${usuario.id}', extra: usuario),
      child: Row(
        children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: usuario.fotoPerfil != null
              ? NetworkImage(usuario.fotoPerfil!)
              : null,
          child: usuario.fotoPerfil == null
              ? const Icon(Icons.person, size: 28, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                usuario.nome,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                tipo,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => _toggleFavorito(usuario.id),
          child: SvgPicture.asset(
            icone,
            width: 36,
            height: 36,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
      ),
    );
  }
}
