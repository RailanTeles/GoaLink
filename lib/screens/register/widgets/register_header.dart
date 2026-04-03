import 'package:flutter/material.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({
    super.key,
    required this.title,
    required this.onBack,
    this.iconSize = 120,
    this.topSpacing = 18,
  });

  final String title;
  final VoidCallback onBack;
  final double iconSize;
  final double topSpacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: onBack,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.10),
            foregroundColor: Colors.white,
            fixedSize: const Size(48, 48),
          ),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        SizedBox(height: topSpacing),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TacticalIcon(size: iconSize),
              const SizedBox(width: 14),
              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontSize: 34,
                    height: 1.05,
                    fontWeight: FontWeight.w800,
                  ),
                  children: [
                    TextSpan(
                      text: 'Cadastro\n',
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                    TextSpan(
                      text: title,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 14),
              _TacticalIcon(size: iconSize),
            ],
          ),
        ),
      ],
    );
  }
}

class _TacticalIcon extends StatelessWidget {
  const _TacticalIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_app.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
