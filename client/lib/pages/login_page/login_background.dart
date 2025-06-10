import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  final bool expanded;
  const LoginBackground({
    super.key,
    this.expanded = true,
  });

  Widget background() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 53, 76, 255),
            Color.fromARGB(255, 202, 69, 255),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return expanded ? Expanded(
      child: background(),
    ) : background();
  }
}