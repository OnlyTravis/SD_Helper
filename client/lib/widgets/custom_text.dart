import 'package:flutter/material.dart';

class SimpleText extends StatelessWidget {
  final String text;
  final double? scale;
  final FontWeight? weight;
  final Color? color;

  const SimpleText(
    this.text,
  {
    super.key,
    this.scale,
    this.color,
    this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textScaler: (scale == null) ? null : TextScaler.linear(scale!),
      style: TextStyle(
        color: color,
        fontWeight: weight,
      ),
    );
  }
}