import 'package:client/widgets/text_icon_button.dart';
import 'package:flutter/material.dart';

class FolderPageActionButtonGroup extends StatelessWidget {
  final bool isEditing;
  final bool fileOnly;
  final bool folderOnly;
  final bool singleFile;
  final bool singleFolder;
  final VoidCallback onRenameFile;
  final VoidCallback onMassRenameFiles;
  final VoidCallback onRenameFolder;
  final VoidCallback onMove;
  final VoidCallback onDelete;

  const FolderPageActionButtonGroup({
    super.key,
    required this.isEditing,
    required this.fileOnly,
    required this.folderOnly,
    required this.singleFile,
    required this.singleFolder,
    required this.onRenameFile,
    required this.onMassRenameFiles,
    required this.onRenameFolder,
    required this.onMove,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    const double buttonWidth = 64;
    return AnimatedPositioned(
      right: 16,
      bottom: isEditing ? 16 : -64,
      duration: const Duration(milliseconds: 150),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (fileOnly && singleFile) TextIconButton(
              width: buttonWidth,
              onTap: onRenameFile, 
              icon: const Icon(Icons.drive_file_rename_outline), 
              text: const Text("Rename"),
            ),
            if (fileOnly && !singleFile) TextIconButton(
              width: buttonWidth,
              onTap: onMassRenameFiles, 
              icon: const Icon(Icons.drive_file_rename_outline), 
              text: const Text("Rename"),
            ),
            if (folderOnly && singleFolder) TextIconButton(
              width: buttonWidth,
              onTap: onRenameFolder, 
              icon: const Icon(Icons.drive_file_rename_outline), 
              text: const Text("Rename"),
            ),

            TextIconButton(
              width: buttonWidth,
              onTap: onMove, 
              icon: const ImageIcon(AssetImage("icons/folder_move.png")), 
              text: const Text("Move"),
            ),
            TextIconButton(
              width: buttonWidth,
              onTap: onDelete, 
              icon: const Icon(Icons.delete), 
              text: const Text("Delete"),
            ),
          ],
        ),
      ),
    );
  }
}