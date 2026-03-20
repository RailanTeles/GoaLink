import 'package:flutter/material.dart';

class PainelInferior extends StatefulWidget {
  const PainelInferior({super.key, required this.alturaContainer});
  final double alturaContainer;

  @override
  State<PainelInferior> createState() => _PainelInferiorState();
}

class _PainelInferiorState extends State<PainelInferior> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutQuart,
      width: double.infinity,
      height: widget.alturaContainer,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.75),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: const SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(),
      ),
    );
  }
}
