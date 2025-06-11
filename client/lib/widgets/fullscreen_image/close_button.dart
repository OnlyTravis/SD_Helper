import 'package:flutter/material.dart';

class FullscreenImageCloseButton extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onTap;

  const FullscreenImageCloseButton({
    super.key,
    required this.isVisible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: isVisible ? 16 : -48,
      right: 16,
      duration: const Duration(milliseconds: 100),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          Icons.cancel, 
          color: const Color.fromARGB(255, 48, 48, 48).withAlpha(100),
          size: 48,
        ),
      ),
    );
  }
}