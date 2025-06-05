import 'package:flutter/material.dart';

class MainNavigationListview extends StatefulWidget {
  final Widget? header;

  const MainNavigationListview({
    super.key,
    this.header,
  });

  @override
  State<MainNavigationListview> createState() => _MainNavagationListViewState();
}
class _MainNavagationListViewState extends State<MainNavigationListview> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (widget.header != null) widget.header!,
        const ListTile(
          leading: Icon(Icons.home),
          title: Text("Home"),
        ),
        const ListTile(
          leading: Icon(Icons.folder),
          title: Text("Folders"),
        )
      ],
    );
  }
}