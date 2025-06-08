import 'package:client/page_templates/main_navigation/main_navigation.dart';
import 'package:client/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final url = dotenv.get("SERVER_URL");
    http.get(
      Uri.parse("$url/api/getFolder?folder=/"),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MainNavigationWrap(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SimpleText(text: "Welcome Back", scale: 2, weight: FontWeight.bold)
          ],
        ),
      ),
    );
  }
}