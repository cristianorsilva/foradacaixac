import 'package:flutter/material.dart';

class TextButtonFC extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const TextButtonFC({super.key, required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        key: key,
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.only(left: 50, right: 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)));
  }
}
