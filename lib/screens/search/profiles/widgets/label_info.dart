import 'package:flutter/material.dart';

class LabelInfo extends StatelessWidget {
  const LabelInfo({
    super.key,
    required this.icone,
    required this.textoTitulo,
    required this.textoLabel,
  });
  final IconData icone;
  final String textoTitulo;
  final String textoLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .start,
      children: [
        Row(
          children: [
            Icon(icone, color: Theme.of(context).primaryColor),
            const SizedBox(width: 5),
            Text(
              textoTitulo,
              style: TextStyle(color: Colors.grey, fontWeight: .bold),
            ),
          ],
        ),
        Text(textoLabel, style: const TextStyle(fontWeight: .bold)),
      ],
    );
  }
}
