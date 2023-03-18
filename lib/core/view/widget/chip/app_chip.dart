import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  final String chipText;
  final Color backgroundColor;
  final double borderWidth;
  final Color borderColor;

  const AppChip(
      {super.key,
      required this.chipText,
      required this.backgroundColor,
      required this.borderWidth,
      required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return const Chip(
      label: Text("My name is Echomix"),
      backgroundColor: Colors.white24,
      side: BorderSide(width: 1.0, color: Colors.white),
    );
  }
}
