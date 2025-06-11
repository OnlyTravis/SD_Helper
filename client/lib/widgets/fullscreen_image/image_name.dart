import 'package:flutter/material.dart';

class FullscreenImageName extends StatelessWidget {
  final bool visible;
  final Widget imageName;

  const FullscreenImageName({
    super.key,
    required this.visible,
    required this.imageName,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: 16,
      bottom: visible ? 16 : -80,
      duration: const Duration(milliseconds: 100),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 200,
        ),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer.withAlpha(100),
          borderRadius: BorderRadius.circular(10),
        ),
        child: imageName,
      ),
    );
  }
}