import 'package:flutter/material.dart';

class FullscreenImageSideButton extends StatelessWidget {
  final Alignment align;
  final IconData icon;
  final VoidCallback onTap;

  const FullscreenImageSideButton({
    super.key,
    required this.align,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align,
      child: Material(
        color: const Color.fromARGB(0, 255, 255, 255),
        child: SizedBox(
          width: 250,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: Icon(icon, size: 64, color: const Color.fromARGB(81, 200, 255, 249)),
            ),
          ),
        ),
      ),
    );
  }
}