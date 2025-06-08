import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  final Color? color;
  final BoxShadow? boxShadow;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback onPressed;
  final Widget child;

  const CardButton({
    super.key, 
    this.color, 
    this.boxShadow,
    this.padding, 
    this.margin,
    required this.onPressed,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: margin,
      decoration: BoxDecoration(
        boxShadow: [
          boxShadow ?? BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withAlpha(32),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(1, 1), // changes position of shadow
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Material(
        color: (color ?? Theme.of(context).colorScheme.surfaceContainerLow),
        child: InkWell(
          onTap: onPressed,
          child: (padding == null) ? child : Padding(padding: padding!, child: child),
        ),
      ),
    );
  }
}