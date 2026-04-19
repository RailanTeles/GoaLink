import 'package:flutter/material.dart';

class RegisterPhotoPickerButton extends StatelessWidget {
  const RegisterPhotoPickerButton({
    super.key,
    required this.onTap,
    this.nomeArquivo,
  });

  final VoidCallback onTap;
  final String? nomeArquivo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Foto de Perfil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFD8D8D8),
              foregroundColor: Colors.black,
              side: BorderSide(
                color: Colors.white.withValues(alpha: 0.55),
                width: 2,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.photo_camera_outlined, size: 28),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    nomeArquivo ?? 'Insira a foto aqui',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
