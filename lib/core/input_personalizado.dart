import 'package:flutter/material.dart';

class InputPersonalizado extends StatefulWidget {
  const InputPersonalizado({
    super.key,
    required this.labelText,
    required this.prefixIcon,
    this.isPassword = false,
    required this.controller,
  });
  final String labelText;
  final IconData prefixIcon;
  final bool isPassword;

  final TextEditingController controller;

  @override
  State<InputPersonalizado> createState() => _InputPersonalizadoState();
}

class _InputPersonalizadoState extends State<InputPersonalizado> {
  bool _ocultarSenha = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _ocultarSenha : false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: widget.labelText,
          prefixIcon: Icon(widget.prefixIcon),
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _ocultarSenha = !_ocultarSenha;
                    });
                  },
                  icon: Icon(
                    _ocultarSenha ? Icons.visibility : Icons.visibility_off,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
