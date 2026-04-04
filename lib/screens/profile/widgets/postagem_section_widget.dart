import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';

class PostagemSectionWidget extends StatelessWidget {
  const PostagemSectionWidget({super.key, required this.usuario});

  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    final avatarProvider =
        (usuario.fotoPerfil != null && usuario.fotoPerfil!.isNotEmpty)
        ? NetworkImage(usuario.fotoPerfil!)
        : const AssetImage('assets/images/background.png') as ImageProvider;
    final userHandle = '${usuario.nome.toLowerCase().split(' ').first}@';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 28, backgroundImage: avatarProvider),
            const SizedBox(width: 12),
            Text(
              userHandle,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: 310,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.2),
                  color: const Color(0xFFD8DEE4),
                ),
                child: CustomPaint(
                  painter: _PlaceholderPainter(),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                IconButton(
                  onPressed: () {},
                  iconSize: 34,
                  color: const Color(0xFFE32121),
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
                const SizedBox(height: 12),
                Transform.rotate(
                  angle: -0.25,
                  child: IconButton(
                    onPressed: () {},
                    iconSize: 32,
                    color: const Color(0xFF948A2A),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _PlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = const Color(0xFFD3DAE1);
    final shapePaint = Paint()..color = const Color(0xFFF5F7F9);

    canvas.drawRect(Offset.zero & size, backgroundPaint);
    canvas.drawCircle(
      Offset(size.width * 0.29, size.height * 0.44),
      18,
      shapePaint,
    );

    final path = Path()
      ..moveTo(0, size.height * 0.64)
      ..quadraticBezierTo(
        size.width * 0.08,
        size.height * 0.53,
        size.width * 0.18,
        size.height * 0.60,
      )
      ..quadraticBezierTo(
        size.width * 0.26,
        size.height * 0.67,
        size.width * 0.33,
        size.height * 0.73,
      )
      ..quadraticBezierTo(
        size.width * 0.41,
        size.height * 0.78,
        size.width * 0.49,
        size.height * 0.61,
      )
      ..quadraticBezierTo(
        size.width * 0.66,
        size.height * 0.22,
        size.width * 0.82,
        size.height * 0.34,
      )
      ..quadraticBezierTo(
        size.width * 0.91,
        size.height * 0.42,
        size.width,
        size.height * 0.66,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, shapePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
