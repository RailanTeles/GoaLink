import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/services/usuario_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _usuarioService = UsuarioService();
  List<UsuarioModel>? _listaUsuarios;

  Future<void> _pesquisarNome(String nome) async {
    if (nome.trim() == "") {
      setState(() {
        _listaUsuarios = null;
      });
      return;
    }
    final usuarios = await _usuarioService.getUsuariosPorNome(nome);
    setState(() {
      _listaUsuarios = usuarios;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: TextField(
                onChanged: _pesquisarNome,
                decoration: InputDecoration(
                  hintText: "Pesquisar usuários...",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  ),
                  filled: true,
                  fillColor: Colors.grey.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_listaUsuarios == null)
            const SliverToBoxAdapter(child: SizedBox.shrink())
          else if (_listaUsuarios!.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  "Nenhum perfil encontrado",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              sliver: SliverList.builder(
                itemCount: _listaUsuarios!.length,
                itemBuilder: (context, index) {
                  final usuario = _listaUsuarios![index];
                  return ListTile(title: Text(usuario.nome));
                },
              ),
            ),
        ],
      ),
    );
  }
}
