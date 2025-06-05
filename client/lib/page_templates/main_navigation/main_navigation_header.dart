import 'package:flutter/material.dart';

class MainNavigationHeader extends StatelessWidget {
  const MainNavigationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 80,
      child: DrawerHeader(
        child: Text(
          "SD Helper",
          textScaler: TextScaler.linear(1.5),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}