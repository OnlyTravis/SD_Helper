import 'package:client/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class FolderPageTopBar extends StatelessWidget {
  final String folderPath;
  final int selectedCount;

  const FolderPageTopBar({
    super.key,
    required this.folderPath,
    required this.selectedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Row(
        children: [
          SimpleText("Current Folder : '$folderPath'", scale: 1.4),
          if (selectedCount > 0) ...[
            const SizedBox(width: 16),
            SimpleText("Selected : $selectedCount", scale: 1.4),
          ]
        ],
      ),
    );
  }
}