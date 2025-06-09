import 'package:client/code/fetch.dart';
import 'package:client/widgets/folder_card.dart';
import 'package:flutter/material.dart';

class FileCard extends StatelessWidget {
  final String folderPath;
  final FileObject file;
  final double size;
  final void Function(FileObject)? onTap;
  final void Function(FileObject)? onLongPress;

  const FileCard({
    super.key,
    required this.folderPath,
    required this.file,
    this.size = 64,
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
          HttpServer.fileUrl("$folderPath/${file.fileName}"),
          width: size,
          height: size,
        );
        break;
      default:
        fileIcon = Icon(Icons.file_copy, size: size, color: Theme.of(context).colorScheme.primaryContainer);
        break;
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: (onTap == null) ? null : () => onTap!(file),
        onLongPress: (onLongPress == null) ? null : () => onLongPress!(file),
        child: SizedBox(
          width: size+32,
          height: size+32,
          child: Column(
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
    );
  }
}