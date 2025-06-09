import 'package:client/page_templates/main_navigation/main_navigation.dart';
import 'package:flutter/material.dart';

class _Navigation {
  final Pages page;
  final String pageName;
  final IconData pageIcon;
  const _Navigation({
    required this.page,
    required this.pageName,
    required this.pageIcon,
  });
}

class MainNavigationListview extends StatefulWidget {
  final Widget? header;
  final void Function(Pages) onNavigate;

  const MainNavigationListview({
    super.key,
    this.header,
    required this.onNavigate,
  });

  @override
  State<MainNavigationListview> createState() => _MainNavagationListViewState();
}
class _MainNavagationListViewState extends State<MainNavigationListview> {
  static const navigations = [
    _Navigation(page: Pages.HomePage, pageName: "Home", pageIcon: Icons.home),
    _Navigation(page: Pages.FolderPage, pageName: "Folder", pageIcon: Icons.folder),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (widget.header != null) widget.header!,
        ...navigations.map((navigation) => _NavigationButton(
          pageIcon: Icon(navigation.pageIcon), 
          pageText: Text(navigation.pageName), 
          onClick: () => widget.onNavigate(navigation.page),
        )),
      ],
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final Widget pageIcon;
  final Widget pageText;
  final VoidCallback onClick;

  const _NavigationButton({
    required this.pageIcon,
    required this.pageText,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: ListTile(
            onTap: onClick,
            leading: pageIcon,
            title: pageText,
        ),
    );
  }
}