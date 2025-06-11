import 'package:flutter/material.dart';

class TextIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget icon;
  final Text text;

  const TextIconButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap, 
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          text,
        ],
      )
    );
  }
}