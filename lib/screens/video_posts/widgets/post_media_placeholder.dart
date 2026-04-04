import 'package:flutter/material.dart';

class PostMediaPlaceholder extends StatelessWidget {
  const PostMediaPlaceholder({super.key, this.large = false});

  final bool large;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF1E6B47);

    if (large) {
      return Container(
        width: 178,
        height: 178,
        decoration: BoxDecoration(
          border: Border.all(color: green, width: 3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(
            Icons.add_photo_alternate_outlined,
            size: 86,
            color: green,
          ),
        ),
      );
    }

    return CustomPaint(
      painter: _PlaceholderPainter(),
      child: const SizedBox.expand(),
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
