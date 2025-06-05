import 'package:client/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';

class SDHelperApp extends StatelessWidget {
  const SDHelperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SD Helper",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 160, 252, 255),
          brightness: Brightness.light
        ),
      ),
      home: HomePage(),
    );
  }
}