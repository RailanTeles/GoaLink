import 'dart:ui';

import 'package:flutter/material.dart';

class RegisterBackground extends StatelessWidget {
  const RegisterBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/background.png', fit: BoxFit.cover),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(color: Colors.black.withValues(alpha: 0.58)),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.72),
                Colors.black.withValues(alpha: 0.86),
                Colors.black.withValues(alpha: 0.94),
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }
}
