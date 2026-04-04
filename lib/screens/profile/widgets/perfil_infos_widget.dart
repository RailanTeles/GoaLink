import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';
import 'package:goalink/screens/profile/widgets/label_info_widget.dart';
import 'package:goalink/screens/profile/widgets/social_infos_widgets.dart';

class PerfilInfosWidget extends StatelessWidget {
  const PerfilInfosWidget({super.key, required this.usuario});

  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: LabelInfoWidget(
                title: 'Cidade',
                value: usuario.cidade ?? '-',
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: LabelInfoWidget(
                title: 'Posição',
                value: usuario.posicao ?? '-',
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        LabelInfoWidget(
          title: 'Perna',
          value: usuario.pernaPreferida ?? '-',
        ),
        const SizedBox(height: 18),
        LabelInfoWidget(
          title: 'Descrição',
          value: usuario.descricao ?? '-',
        ),
        const SizedBox(height: 18),
        SocialInfosWidgets(redesSociais: usuario.redesSociais),
      ],
    );
  }
}
