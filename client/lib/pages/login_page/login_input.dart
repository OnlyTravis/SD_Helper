import 'dart:math';

import 'package:flutter/material.dart';

class _LoginInputTransition extends AnimatedWidget {
  final Widget child;

  const _LoginInputTransition({
    required Animation<double> animation,
    required this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double> _animation = listenable as Animation<double>;

    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.tertiaryContainer,
              Theme.of(context).colorScheme.tertiaryContainer,
              Theme.of(context).colorScheme.secondaryContainer,
              Theme.of(context).colorScheme.tertiaryContainer,
              Theme.of(context).colorScheme.tertiaryContainer,
            ],
            stops: [0, _animation.value*_animation.value, _animation.value, sqrt(_animation.value), 1]
          )
        ),
        child: child
      ),
    );
  }
}

class LoginInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget prefixIcon;

  const LoginInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
  });

  @override
  State<LoginInputField> createState() => _LoginInputFieldState();
}
class _LoginInputFieldState extends State<LoginInputField> with SingleTickerProviderStateMixin {
  late AnimationController _animation;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _animation.value = 1;
  }

  @override
  Widget build(BuildContext context) {
    return _LoginInputTransition(
      animation: _animation,
      child: TextField(
        controller: widget.controller,
        obscureText: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          prefixIcon: widget.prefixIcon,
          hintText: widget.hintText,
        ),
        onTapOutside: (_) {
          setState(() {
            _animation.value = 0;
            _animation.forward();
          });
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }
}