import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldFC extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? obscureText;

  const TextFormFieldFC(
      {super.key,
      required this.labelText,
      required this.hintText,
      this.keyboardType,
      this.inputFormatters,
      this.controller,
      this.validator,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
        labelText: labelText,
        hintText: hintText,
        floatingLabelStyle: const TextStyle(color: Colors.deepPurple),
        hintStyle: const TextStyle(
          color: Colors.deepPurple,
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      controller: controller,
      validator: validator,
      obscureText: obscureText ?? false,
    );
  }
}
