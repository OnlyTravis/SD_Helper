import 'package:flutter/material.dart';

class TextIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget icon;
  final Text text;
  final double? width;

  const TextIconButton({
    super.key,
    this.width,
    required this.onTap,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap, 
      icon: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            text,
          ],
        ),
      ),
    );
  }
}