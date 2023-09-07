import 'package:flutter/material.dart';

class ElevatedButtonFC extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const ElevatedButtonFC({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        key: key,
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: const EdgeInsets.only(left: 50, right: 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(label));
  }
}
