import 'package:client/page_templates/main_navigation/main_navigation_header.dart';
import 'package:client/page_templates/main_navigation/main_navigation_listview.dart';
import 'package:client/page_templates/main_navigation/to_page.dart';
import 'package:client/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

enum Pages {
  LoginPage,
  HomePage,
  FolderPage,
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({
    super.key,
  });

  @override
  State<MainNavigation> createState() => _MainNavagationState();
}
class _MainNavagationState extends State<MainNavigation> {
  static Pages selected = Pages.HomePage;

  void navigateTo(Pages page) {
    setState(() {
      selected = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final child = toPage(selected);

    return ResponsiveLayout(
      mobileBody: Scaffold(
        endDrawer: Drawer(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: MainNavigationListview(
            header: const MainNavigationHeader(),
            onNavigate: navigateTo,
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text("SD Helper"),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            child,
          ],
        ),
      ),
      desktopBody: Scaffold(
        body: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              width: 200,
              child: MainNavigationListview(
                header: const MainNavigationHeader(),
                onNavigate: navigateTo,
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}