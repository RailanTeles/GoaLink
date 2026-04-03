import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterInputField extends StatelessWidget {
  const RegisterInputField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.hintText,
    this.maxLines = 1,
    this.minLines,
    this.inputFormatters,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? hintText;
  final int maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          minLines: minLines,
          inputFormatters: inputFormatters,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.92),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 20,
            ),
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.white, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
