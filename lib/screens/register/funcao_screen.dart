import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class FuncaoScreen extends StatelessWidget {
  const FuncaoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/background.png', fit: BoxFit.cover),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: Colors.black.withValues(alpha: 0.60)),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.68),
                  Colors.black.withValues(alpha: 0.82),
                  Colors.black.withValues(alpha: 0.94),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.10),
                      foregroundColor: Colors.white,
                      fixedSize: const Size(48, 48),
                    ),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const SizedBox(height: 22),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/logo_app.png',
                          width: 94,
                          height: 94,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 14),
                        Text.rich(
                          TextSpan(
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Goa',
                                style: TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: 'Link',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _FuncaoButton(
                    assetPath: 'assets/images/icons/bola_de_futebol.svg',
                    label: 'Jogador',
                    iconSize: 38,
                    onTap: () {
                      context.go('/cadastro');
                    },
                  ),
                  const SizedBox(height: 26),
                  _FuncaoButton(
                    assetPath: 'assets/images/icons/equipamentodefutebol.svg',
                    label: 'Olheiro',
                    iconSize: 42,
                    onTap: () {
                      context.go('/cadastro/olheiro');
                    },
                  ),
                  const SizedBox(height: 26),
                  _FuncaoButton(
                    assetPath: 'assets/images/icons/clubedefutebol.svg',
                    label: 'Clube',
                    iconSize: 46,
                    onTap: () {
                      context.go('/cadastro/clube');
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FuncaoButton extends StatelessWidget {
  const _FuncaoButton({
    required this.assetPath,
    required this.label,
    required this.onTap,
    this.iconSize = 42,
  });

  final String assetPath;
  final String label;
  final VoidCallback onTap;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final green = Theme.of(context).colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: green.withValues(alpha: 0.38),
            blurRadius: 0,
            spreadRadius: 2,
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE8E8E8),
            foregroundColor: Colors.black,
            elevation: 0,
            minimumSize: const Size.fromHeight(82),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
              side: BorderSide(color: green, width: 2),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: SvgPicture.asset(
                    assetPath,
                    width: iconSize,
                    height: iconSize,
                    colorFilter: const ColorFilter.mode(
                      Colors.black87,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }
}
