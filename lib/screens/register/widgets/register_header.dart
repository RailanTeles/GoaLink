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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final compact = screenWidth < 420;
    final resolvedIconSize = compact ? iconSize * 0.52 : iconSize;
    final titleStyle = TextStyle(
      fontSize: compact ? 24 : 34,
      height: 1.05,
      fontWeight: FontWeight.w800,
    );

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TacticalIcon(size: resolvedIconSize),
              SizedBox(width: compact ? 8 : 14),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Cadastro',
                    style: titleStyle.copyWith(color: theme.colorScheme.primary),
                  ),
                  Text(
                    title,
                    style: titleStyle.copyWith(color: Colors.white),
                  ),
                ],
              ),
              SizedBox(width: compact ? 8 : 14),
              _TacticalIcon(size: resolvedIconSize),
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
