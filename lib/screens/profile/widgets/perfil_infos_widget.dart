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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LabelInfoWidget(
                icon: Icons.location_on,
                title: 'Cidade',
                value: usuario.cidade ?? '-',
              ),
            ),
            const SizedBox(width: 40),
            Expanded(
              child: LabelInfoWidget(
                icon: Icons.sports_soccer_outlined,
                title: 'Posição',
                value: usuario.posicao ?? '-',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LabelInfoWidget(
          icon: Icons.directions_run,
          title: 'Perna Preferida',
          value: usuario.pernaPreferida ?? '-',
        ),
        const SizedBox(height: 16),
        LabelInfoWidget(
          icon: Icons.description,
          title: 'Descrição',
          value: usuario.descricao ?? '-',
        ),
        const SizedBox(height: 18),
        SocialInfosWidgets(redesSociais: usuario.redesSociais),
      ],
    );
  }
}
