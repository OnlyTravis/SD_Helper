import 'package:client/page_templates/main_navigation/main_navigation_header.dart';
import 'package:client/page_templates/main_navigation/main_navigation_listview.dart';
import 'package:client/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

class MainNavigationWrap extends StatefulWidget {
  final Widget child;

  const MainNavigationWrap({
    super.key,
    required this.child,
  });

  @override
  State<MainNavigationWrap> createState() => _MainNavagationWrapState();
}
class _MainNavagationWrapState extends State<MainNavigationWrap> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: Scaffold(
        appBar: AppBar(
          title: const Text("SD Helper"),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        endDrawer: const Drawer(
          child: MainNavigationListview(
            header: MainNavigationHeader(),
          ),
        ),
        body: Expanded(child: widget.child),
      ),
      desktopBody: Scaffold(
        body: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              width: 200,
              child: const MainNavigationListview(
                header: MainNavigationHeader(),
              ),
            ),
            Expanded(
              child: widget.child
            ),
          ],
        ),
      ),
    );
  }
}