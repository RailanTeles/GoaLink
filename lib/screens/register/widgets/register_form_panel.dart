import 'package:flutter/material.dart';

class RegisterFormPanel extends StatelessWidget {
  const RegisterFormPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(18, 22, 18, 18),
    this.radius = 26,
    this.alpha = 0.28,
  });

  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: alpha),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}
