import 'package:client/code/fetch.dart';
import 'package:client/widgets/folder_card.dart';
import 'package:flutter/material.dart';

class FileCard extends StatelessWidget {
  final String folderPath;
  final FileObject file;
  final double size;
  final bool isSelected;
  final void Function(FileObject)? onTap;
  final void Function(FileObject)? onLongPress;

  const FileCard({
    super.key,
    required this.folderPath,
    required this.file,
    this.size = 64,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    Widget fileIcon;
    switch (file.fileType) {
      case FileTypes.JSON:
        fileIcon = Icon(Icons.file_copy, size: size, color: Theme.of(context).colorScheme.primaryContainer);
        break;
      case FileTypes.Image:
        fileIcon = Image.network(
          HttpServer.imageUrl("$folderPath/${file.fileName}", true),
          width: size,
          height: size,
        );
        break;
      default:
        fileIcon = Icon(Icons.file_copy, size: size, color: Theme.of(context).colorScheme.primaryContainer);
        break;
    }
    return SizedBox(
      width: size+32,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: (onTap == null) ? null : () => onTap!(file),
              onLongPress: (onLongPress == null) ? null : () => onLongPress!(file),
              child: SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    fileIcon,
                    Text(
                      file.fileName, 
                      textScaler: const TextScaler.linear(0.8),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isSelected) Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.check_box, color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }
}