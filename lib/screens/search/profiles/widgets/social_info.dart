import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialInfo extends StatelessWidget {
  const SocialInfo({super.key, required this.imagem, required this.link});
  final String imagem;
  final String link;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .start,
      children: [
        Image.asset(imagem, width: 20),
        const SizedBox(width: 10),
        Expanded(
          child: InkWell(
            onTap: () {
              _abrirLinkExterno(link);
            },
            child: Text(
              link,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> _abrirLinkExterno(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    debugPrint('Não foi possível abrir o link: $url');
  }
}
