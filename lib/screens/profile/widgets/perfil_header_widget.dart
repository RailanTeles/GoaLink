import 'package:flutter/material.dart';
import 'package:goalink/models/usuario_model.dart';

class PerfilHeaderWidget extends StatelessWidget {
  const PerfilHeaderWidget({super.key, required this.usuario});

  final UsuarioModel usuario;

  int _calcularIdade(DateTime? nascimento) {
    if (nascimento == null) return 0;

    final hoje = DateTime.now();
    var idade = hoje.year - nascimento.year;
    final fezAniversario =
        hoje.month > nascimento.month ||
        (hoje.month == nascimento.month && hoje.day >= nascimento.day);

    if (!fezAniversario) idade--;
    return idade;
  }

  @override
  Widget build(BuildContext context) {
    final idade = _calcularIdade(usuario.dataNascimento);
    final foto = usuario.fotoPerfil;
    final imageProvider = (foto != null && foto.isNotEmpty)
        ? NetworkImage(foto)
        : const AssetImage('assets/images/background.png') as ImageProvider;

    return SizedBox(
      height: 330,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image(
            image: imageProvider,
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.15),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.10),
                  Colors.black.withValues(alpha: 0.18),
                  Colors.black.withValues(alpha: 0.26),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _TopCircleButton(
                      backgroundColor: Colors.white,
                      iconColor: Colors.black,
                      icon: Icons.arrow_back_rounded,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    _TopCircleButton(
                      backgroundColor: const Color(0xFF1E6B47),
                      iconColor: Colors.white,
                      icon: Icons.settings,
                      onTap: () {},
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    if (idade > 0) _HeaderPill(label: '$idade anos'),
                    if (idade > 0) const SizedBox(width: 10),
                    if (usuario.peso != null)
                      _HeaderPill(label: '${usuario.peso} kg'),
                    if (usuario.peso != null) const SizedBox(width: 10),
                    if (usuario.altura != null)
                      _HeaderPill(
                        label: '${usuario.altura!.toStringAsFixed(2)} m',
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopCircleButton extends StatelessWidget {
  const _TopCircleButton({
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
    required this.onTap,
  });

  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: iconColor, size: 24),
        ),
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  const _HeaderPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2E855A),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
