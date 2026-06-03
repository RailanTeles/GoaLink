import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/screens/search/profiles/widgets/label_info.dart';
import 'package:goalink/screens/search/profiles/widgets/social_info.dart';

class ProfileInfos extends StatelessWidget {
  const ProfileInfos({super.key, required this.usuario});
  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    final listaRedesSociais = usuario.redesSociais ?? {};
    return SizedBox(
      width: .infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final larguraItem = (constraints.maxWidth - 16) / 2;
          return Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              if (usuario.tipo == "jogador") ...[
                Wrap(
                  spacing: 16,
                  runSpacing: 20,
                  children: [
                    // Informações Primárias
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
              ],

              // Informações do Olheiro
              if (usuario.tipo == "olheiro") ...[
                Wrap(
                  spacing: 16,
                  runSpacing: 20,
                  children: [
                    if (usuario.clubeRepresentante != null &&
                        usuario.clubeRepresentante!.isNotEmpty)
                      SizedBox(
                        width: larguraItem,
                        child: LabelInfo(
                          icone: Icons.shield,
                          textoTitulo: "Agente/Empresa",
                          textoLabel: usuario.clubeRepresentante!,
                        ),
                      ),

                    if (usuario.jogadoresProcurados != null &&
                        usuario.jogadoresProcurados!.isNotEmpty)
                      SizedBox(
                        width: larguraItem,
                        child: LabelInfo(
                          icone: Icons.group,
                          textoTitulo: "Jogadores Procurados",
                          textoLabel: usuario.jogadoresProcurados!,
                        ),
                      ),
                  ],
                ),
              ],

              // Informações do clube
              if (usuario.tipo == "clube") ...[
                if (usuario.cidade != null && usuario.cidade!.isNotEmpty)
                  SizedBox(
                    width: larguraItem,
                    child: LabelInfo(
                      icone: Icons.location_pin,
                      textoTitulo: "Cidade",
                      textoLabel: usuario.cidade!,
                    ),
                  ),
                if (usuario.jogadoresProcurados != null &&
                    usuario.jogadoresProcurados!.isNotEmpty)
                  SizedBox(
                    width: larguraItem,
                    child: LabelInfo(
                      icone: Icons.group,
                      textoTitulo: "Jogadores Procurados",
                      textoLabel: usuario.jogadoresProcurados!,
                    ),
                  ),
              ],

              // Comum a todos -------------------------------
              // Descrição
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

              // Redes Sociais
              if (listaRedesSociais.isNotEmpty) ...[
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
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
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: .bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 16,
                  runSpacing: 20,
                  children: [
                    for (var e in listaRedesSociais.entries)
                      SocialInfo(
                        imagem: "assets/images/${e.key}.png",
                        link: e.value.toString(),
                      ),
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
