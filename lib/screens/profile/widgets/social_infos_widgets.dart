import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialInfosWidgets extends StatelessWidget {
  const SocialInfosWidgets({super.key, required this.redesSociais});

  final Map<String, dynamic>? redesSociais;

  @override
  Widget build(BuildContext context) {
    final instagram = redesSociais?['instagram']?.toString() ?? '';

    if (instagram.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.computer_outlined,
              size: 18,
              color: Color(0xFF2C6D49),
            ),
            const SizedBox(width: 8),
            const Text(
              'Redes Sociais',
              style: TextStyle(
                color: Color(0xFF7D847F),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF2C6D49), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: SizedBox(
                      width: 11,
                      height: 11,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(
                            BorderSide(color: Color(0xFF2C6D49), width: 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2C6D49),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: InkWell(
                onTap: () async {
                  final uri = Uri.tryParse(instagram);
                  if (uri == null) return;
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                child: Text(
                  instagram,
                  style: const TextStyle(
                    color: Color(0xFF2E7DDA),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF2E7DDA),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
