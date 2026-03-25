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
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _ocultarSenha : false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: const TextStyle(color: Colors.white),
          prefixIcon: Icon(widget.prefixIcon, color: Colors.white),
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _ocultarSenha = !_ocultarSenha;
                    });
                  },
                  icon: Icon(
                    _ocultarSenha ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white54,
                  ),
                )
              : null,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: Colors.white, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
