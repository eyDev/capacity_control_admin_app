import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  const InputField({
    Key? key,
    required this.label,
    required this.regexPattern,
    required this.inputType,
    required this.controller,
  }) : super(key: key);

  final String label;
  final RegExp regexPattern;
  final TextInputType inputType;
  final TextEditingController controller;

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.label == 'Contraseña',
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.label,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Rellene el campo.';
        } else if (!widget.regexPattern.hasMatch(value)) {
          return 'El campo es incorrecto.';
        } else {
          return null;
        }
      },
      keyboardType: widget.inputType,
    );
  }
}
