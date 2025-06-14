import 'package:flutter/material.dart';

/*interface FileObject {
    file_name: string,
    file_type: FileTypes
}
interface FolderObject {
    parent: string,
    folder_name: string,
    folder_path: string,
    objects: Array<FolderObject | FileObject>,
}*/
enum FileTypes {
  Image,
  JSON,
  Others,
}
class FileObject {
  final String fileName;
  final FileTypes fileType;

  const FileObject({
    required this.fileName,
    required this.fileType,
  });

  FileObject.fromMap(Map<String, dynamic> map):
    fileName = map["file_name"] as String,
    fileType = FileTypes.values[map["file_type"]];
  
  @override
  String toString() {
    return """FileObject({
      fileName: $fileName,
      fileType: $fileType,
    })""";
  }
}
class FolderObject {
  final String parent;
  final String folderName;
  final String folderPath;
  final List<FolderObject> folders;
  final List<FileObject> files;

  const FolderObject({
    required this.parent,
    required this.folderName,
    required this.folderPath,
    required this.folders,
    required this.files,
  });

  FolderObject.fromMap(Map<String, dynamic> map):
    parent = map["parent"] as String,
    folderName = map["folder_name"] as String,
    folderPath = map["folder_path"] as String,
    folders = [...map["folders"].map((folderMap) => FolderObject.fromMap(folderMap))],
    files = [...map["files"].map((fileMap) => FileObject.fromMap(fileMap))];
  const FolderObject.back():
    parent = "..", folderName = "..", folderPath = "..", folders = const [], files = const [];
  const FolderObject.loading():
    parent = "Loading...", folderName = "Loading...", folderPath = "Loading...", folders = const [], files = const [];
  
  @override
  String toString() {
    return """FolderObject({
      parent: $parent,
      folderName: $folderName,
      folderPath: $folderPath,
      folders: $folders,
      files: $files
    })""";
  }
}

class FolderCard extends StatelessWidget {
  final FolderObject folder;
  final double size;
  final bool isSelected;
  final void Function(FolderObject)? onTap;
  final void Function(FolderObject)? onLongPress;

  const FolderCard({
    super.key,
    required this.folder,
    this.size = 64,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size+32,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: (onTap == null) ? null : () => onTap!(folder),
              onLongPress: (onLongPress == null) ? null : () => onLongPress!(folder),
              child: SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.folder, size: size, color: Theme.of(context).colorScheme.primaryContainer),
                    Text(
                      folder.folderName, 
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