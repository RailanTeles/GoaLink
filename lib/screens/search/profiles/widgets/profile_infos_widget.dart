import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/screens/search/profiles/widgets/label_info.dart';

class ProfileInfos extends StatelessWidget {
  const ProfileInfos({super.key, required this.usuario});
  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: .infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final larguraItem = (constraints.maxWidth - 16) / 2;
          return Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 20,
                children: [
                  if (usuario.cidade != null && usuario.cidade!.isNotEmpty)
                    SizedBox(
                      width: larguraItem,
                      child: LabelInfo(
                        icone: Icons.location_pin,
                        textoTitulo: "Cidade",
                        textoLabel: usuario.cidade!,
                      ),
                    ),

                  if (usuario.posicao != null && usuario.posicao!.isNotEmpty)
                    SizedBox(
                      width: larguraItem,
                      child: LabelInfo(
                        icone: Icons.sports_soccer,
                        textoTitulo: "Posição",
                        textoLabel: usuario.posicao!,
                      ),
                    ),

                  if (usuario.pernaPreferida != null &&
                      usuario.pernaPreferida!.isNotEmpty)
                    SizedBox(
                      width: larguraItem,
                      child: LabelInfo(
                        icone: Icons.directions_run,
                        textoTitulo: "Perna Preferida",
                        textoLabel: usuario.pernaPreferida!,
                      ),
                    ),
                ],
              ),
              // Descrição
            ],
          );
        },
      ),
    );
  }
}
