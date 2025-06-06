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
        mobileBody: const Stack(
          children: [
            LoginBackground(),
            Center(
              child: LoginContainer(
                crossAxisAlignment: CrossAxisAlignment.center,
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