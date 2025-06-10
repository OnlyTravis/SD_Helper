import 'package:client/pages/login_page/login_background.dart';
import 'package:client/pages/login_page/login_container.dart';
import 'package:client/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: Stack(
          children: [
            const LoginBackground(expanded: false),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 300,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withAlpha(130),
                  boxShadow: [
                    const BoxShadow(
                      color: Color.fromARGB(61, 215, 215, 215),
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20)
                ),
                child: const LoginContainer(
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
              ),
            ),
          ],
        ), 
        desktopBody: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const LoginBackground(),
            Container(
              width: 300,
              height: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: const LoginContainer(),
            ),
          ],
        ),
      ),
    );
  }
}