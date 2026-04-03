import 'package:flutter/material.dart';

class RegisterPrimaryButton extends StatelessWidget {
  const RegisterPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.black,
          elevation: 0,
          side: const BorderSide(color: Colors.white, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
