import 'package:flutter/material.dart';

class FullscreenImageButtonGroup extends StatelessWidget {
  final bool isVisible;
  const FullscreenImageButtonGroup({
    super.key,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      right: 16,
      bottom: isVisible ? 16 : -48,
      duration: const Duration(milliseconds: 100),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primaryContainer.withAlpha(100),
        ),
        child: Text("WIPWIPWIPWIPWIP"),
      ), 
    );
  }
}