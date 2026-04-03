import 'package:flutter/material.dart';

class LabelInfo extends StatelessWidget {
  const LabelInfo({
    super.key,
    required this.icone,
    required this.textoTitulo,
    required this.textoLabel,
    this.maximoLinhas = 1,
  });
  final IconData icone;
  final String textoTitulo;
  final String textoLabel;
  final int maximoLinhas;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .start,
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Icon(icone, color: Theme.of(context).primaryColor, size: 20),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                textoTitulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey, fontWeight: .bold),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 25),
            Expanded(
              child: Text(
                textoLabel,
                maxLines: maximoLinhas,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: .bold, fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
