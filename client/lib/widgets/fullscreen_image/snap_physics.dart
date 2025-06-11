import 'package:flutter/material.dart';

class FullscreenImageSnapPhysics extends ScrollPhysics {
  const FullscreenImageSnapPhysics({super.parent});

  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return FullscreenImageSnapPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
    mass: 80,
    stiffness: 100,
    damping: 1,
  );
}