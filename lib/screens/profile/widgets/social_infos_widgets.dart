import 'package:flutter/material.dart';

class SocialInfosWidgets extends StatelessWidget {
  const SocialInfosWidgets({super.key, required this.redesSociais});

  final Map<String, dynamic>? redesSociais;

  bool _hasValue(String key) {
    final value = redesSociais?[key];
    return value != null && value.toString().trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    if (redesSociais == null || redesSociais!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF145237),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Redes Sociais',
              style: TextStyle(
                color: Color(0xFF6D7571),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 26,
          runSpacing: 16,
          children: [
            if (_hasValue('instagram'))
              _SocialButton(
                icon: Icons.camera_alt_outlined,
                outlined: true,
                onTap: () {},
              ),
            if (_hasValue('linkedin'))
              _SocialButton(icon: Icons.work, onTap: () {}),
            if (_hasValue('facebook'))
              _SocialButton(
                icon: Icons.facebook,
                circular: true,
                onTap: () {},
              ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.onTap,
    this.outlined = false,
    this.circular = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool outlined;
  final bool circular;

  @override
  Widget build(BuildContext context) {
    final shape = circular
        ? const CircleBorder()
        : RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

    return Material(
      color: outlined ? Colors.white : const Color(0xFF1E6B47),
      shape: shape,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: Container(
          width: 42,
          height: 42,
          decoration: outlined
              ? ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Color(0xFF1E6B47), width: 2),
                  ),
                )
              : null,
          child: Icon(
            icon,
            size: 24,
            color: outlined ? const Color(0xFF1E6B47) : Colors.white,
          ),
        ),
      ),
    );
  }
}
