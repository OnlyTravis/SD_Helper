import 'package:client/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class _NavigationButton extends StatelessWidget {
  final String text;
  final bool active;
  final double size;
  final VoidCallback onTap;

  const _NavigationButton({
    required this.text,
    required this.active,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: active ? TextButton(
          onPressed: onTap, 
          child: Text(text)
        ) : const Text("."),
      ),
    );
  }
}
class FolderPageNavigationButtons extends StatelessWidget {
  final int currentPage;
  final int maxPage;
  final double buttonSize;
  final void Function(int) toPage;

  const FolderPageNavigationButtons({
    super.key,
    required this.currentPage,
    required this.maxPage,
    this.buttonSize = 40,
    required this.toPage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Page"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (currentPage > 0) ? _NavigationButton(
              text: "<", size: buttonSize, active: true, onTap: () => toPage(currentPage-1)
            ): SizedBox(width: buttonSize),

            _NavigationButton(
              text: (currentPage-2).toString(), 
              size: buttonSize, 
              active: (currentPage > 1), 
              onTap: () => toPage(currentPage-2),
            ),
            _NavigationButton(
              text: (currentPage-1).toString(), 
              size: buttonSize, 
              active: (currentPage > 0), 
              onTap: () => toPage(currentPage-1),
            ),
            SizedBox(
              width: buttonSize+16,
              height: buttonSize+16,
              child: Center(
                child: SimpleText(currentPage.toString(), scale: 1.4),
              )
            ),
            _NavigationButton(
              text: (currentPage+1).toString(), 
              size: buttonSize, 
              active: (currentPage+1 <= maxPage), 
              onTap: () => toPage(currentPage+1),
            ),
            _NavigationButton(
              text: (currentPage+2).toString(), 
              size: buttonSize, 
              active: (currentPage+2 <= maxPage), 
              onTap: () => toPage(currentPage+2),
            ),

            (currentPage < maxPage) ? _NavigationButton(
              text: ">", size: buttonSize, active: true, onTap: () => toPage(currentPage+1)
            ): SizedBox(width: buttonSize),
          ],
        ),
      ],
    );
  }
}