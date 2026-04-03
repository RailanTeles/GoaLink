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
      child: Column(
        mainAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              if (usuario.cidade != null && usuario.cidade!.isNotEmpty) ...[
                LabelInfo(
                  icone: Icons.location_pin,
                  textoTitulo: "cidade",
                  textoLabel: usuario.cidade!,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
