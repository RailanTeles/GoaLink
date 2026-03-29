import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';

class NovosJogadoresWidget extends StatefulWidget {
  const NovosJogadoresWidget({super.key, required this.listaJogadores});
  final List<UsuarioModel> listaJogadores;

  @override
  State<NovosJogadoresWidget> createState() => _NovosJogadoresWidgetState();
}

class _NovosJogadoresWidgetState extends State<NovosJogadoresWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.listaJogadores.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Novos jogadores",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final diametroDaFoto = constraints.maxHeight * 0.60;
              final raioDaFoto = diametroDaFoto / 2;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.listaJogadores.length,
                itemBuilder: (context, index) {
                  final usuario = widget.listaJogadores[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: SizedBox(
                        width: diametroDaFoto + 10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: raioDaFoto,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              backgroundImage:
                                  (usuario.fotoPerfil?.isNotEmpty ?? false)
                                  ? NetworkImage(usuario.fotoPerfil!)
                                  : null,
                              onBackgroundImageError: (_, __) {},
                              child: (usuario.fotoPerfil?.isEmpty ?? true)
                                  ? Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: raioDaFoto,
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              usuario.nome,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
