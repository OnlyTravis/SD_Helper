import 'dart:convert';

import 'package:client/code/fetch.dart';
import 'package:client/pages/login_page/login_input.dart';
import 'package:client/widgets/card_button.dart';
import 'package:client/page_templates/main_navigation/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class LoginContainer extends StatefulWidget {
  final CrossAxisAlignment crossAxisAlignment;
  const LoginContainer({
    super.key,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  State<LoginContainer> createState() => _LoginContainerState();
}
class _LoginContainerState extends State<LoginContainer> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String errorText = "";

  void setErrorText(String text) {
    setState(() {
      errorText = text;
    });
  }
  Future<void> onLogin() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    // 1. Check if inputs are valid
    if (username.isEmpty && password.isEmpty) {
      setErrorText("Please enter a valid Username and Password!");
      return;
    }
    if (username.isEmpty) {
      setErrorText("Please enter a valid Username!");
      return;
    }
    if (password.isEmpty) {
      setErrorText("Please enter a valid Password!");
      return;
    }

    // 2. Send & Check response
    try {
      final url = dotenv.get("SERVER_URL");
      final res = await http.post(
        Uri.parse("$url/login"),
        body: {
          "username": username,
          "password": password
        },
      );
      final body = jsonDecode(res.body);
      if (!body["success"]) {
        setErrorText("Incorrect Username or Password!");
        return;
      }
      setToken(body["token"]);
    } catch (err) {
      setErrorText("An Error occured while logging in!");
      return;
    }

    // 3. Redirect to home page
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const MainNavigation(),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: widget.crossAxisAlignment,
      spacing: 16,
      children: [
        const Text(
          "SD Helper", 
          textScaler: TextScaler.linear(1.8),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        LoginInputField(
            controller: _usernameController,
            hintText: "Username",
            prefixIcon: const Icon(Icons.person),
        ),
        LoginInputField(
            controller: _passwordController,
            hintText: "Password",
            prefixIcon: const Icon(Icons.lock),
            obfuscated: true,
        ),
        if (errorText.isNotEmpty) Text(
          errorText,
          textScaler: const TextScaler.linear(1.2),
          style: const TextStyle(
            color: Colors.red
          ),
        ),
        CardButton(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          onPressed: onLogin,
          child: const Text("Login"),
        ),
      ],
    );
  }
}