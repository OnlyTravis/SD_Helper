import 'package:client/data/global.dart';
import 'package:flutter/material.dart';

bool isWideScreen(BuildContext context) {
  return MediaQuery.of(context).size.aspectRatio >= WIDESCREEN_RATIO;
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget desktopBody;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    required this.desktopBody,
  });

  @override
  Widget build(BuildContext context) {
    return isWideScreen(context) ? desktopBody : mobileBody;
  }
}