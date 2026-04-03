import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/screens/search/profiles/widgets/label_info.dart';
import 'package:goalink/screens/search/profiles/widgets/social_info.dart';

class ProfileInfos extends StatelessWidget {
  const ProfileInfos({super.key, required this.usuario});
  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    final instaDynamic = usuario.redesSociais?['instagram'];
    final linkInstagram = instaDynamic?.toString();
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
              if (usuario.descricao != null &&
                  usuario.descricao!.isNotEmpty) ...[
                SizedBox(height: 20),
                SizedBox(
                  width: constraints.maxWidth,
                  child: LabelInfo(
                    icone: Icons.description,
                    textoTitulo: "Descrição",
                    textoLabel: usuario.descricao!,
                    maximoLinhas: 3,
                  ),
                ),
              ],
              if (usuario.redesSociais != null &&
                  usuario.redesSociais!.isNotEmpty) ...[
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.computer_sharp,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        "Redes Sociais",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey, fontWeight: .bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: .start,
                  spacing: 16,
                  children: [
                    if (linkInstagram != null && linkInstagram.isNotEmpty) ...[
                      SizedBox(
                        width: constraints.maxWidth,
                        child: SocialInfo(
                          imagem: "assets/images/instagram.png",
                          link: linkInstagram,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
