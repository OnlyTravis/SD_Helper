import 'package:client/code/fetch.dart';
import 'package:client/page_templates/main_navigation/main_navigation.dart';
import 'package:client/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  Future<void> fetchFolders() async {
    await fetchServerAPI("getFolder?folder=/");
  }

  @override
  void initState() {
    fetchFolders();
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