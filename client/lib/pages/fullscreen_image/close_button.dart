import 'package:flutter/material.dart';

class FullscreenImageCloseButton extends StatelessWidget {
  final bool visible;
  final VoidCallback onTap;

  const FullscreenImageCloseButton({
    super.key,
    required this.visible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: visible ? 16 : -80,
      right: 16,
      duration: const Duration(milliseconds: 100),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          Icons.cancel, 
          color: Theme.of(context).colorScheme.primaryContainer.withAlpha(100),
          size: 48,
        ),
      ),
    );
  }
}