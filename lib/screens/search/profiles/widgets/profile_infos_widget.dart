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
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double espacamentoHorizontal = 16.0;
          const double espacamentoVertical = 20.0;

          final larguraItem =
              (constraints.maxWidth - espacamentoHorizontal) / 2;

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------------------------------------------------------------
              // SEÇÃO 1: INFORMAÇÕES DO JOGADOR
              // ---------------------------------------------------------------------
              if (usuario.tipo == "jogador") ...[
                Wrap(
                  spacing: espacamentoHorizontal,
                  runSpacing: espacamentoVertical,
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
              ],

              // ---------------------------------------------------------------------
              // SEÇÃO 2: INFORMAÇÕES DO OLHEIRO
              // ---------------------------------------------------------------------
              if (usuario.tipo == "olheiro") ...[
                Wrap(
                  spacing: espacamentoHorizontal,
                  runSpacing: espacamentoVertical,
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
                          maximoLinhas: 4,
                        ),
                      ),
                  ],
                ),
              ],

              // ---------------------------------------------------------------------
              // SEÇÃO 3: INFORMAÇÕES DO CLUBE
              // ---------------------------------------------------------------------
              if (usuario.tipo == "clube") ...[
                Wrap(
                  spacing: espacamentoHorizontal,
                  runSpacing: espacamentoVertical,
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
                    if (usuario.jogadoresProcurados != null &&
                        usuario.jogadoresProcurados!.isNotEmpty)
                      SizedBox(
                        width: larguraItem,
                        child: LabelInfo(
                          icone: Icons.group,
                          textoTitulo: "Jogadores Procurados",
                          textoLabel: usuario.jogadoresProcurados!,
                          maximoLinhas: 4,
                        ),
                      ),
                  ],
                ),
              ],

              // ---------------------------------------------------------------------
              // SEÇÕES COMUNS A TODOS
              // ---------------------------------------------------------------------

              // Descrição
              if (usuario.descricao != null &&
                  usuario.descricao!.isNotEmpty) ...[
                const SizedBox(height: 24),
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
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.computer_sharp,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Redes Sociais",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
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
