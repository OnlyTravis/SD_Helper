import 'dart:convert';

import 'package:client/code/fetch.dart';
import 'package:client/widgets/custom_text.dart';
import 'package:client/widgets/file_card.dart';
import 'package:client/widgets/folder_card.dart';
import 'package:flutter/material.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({super.key});

  @override
  State<FolderPage> createState() => _FolderPageState();
}
class _FolderPageState extends State<FolderPage> {
  bool isOpeningFolder = false;
  FolderObject currentFolder = const FolderObject.loading();

  Future<void> openFolder(String folderPath) async {
    // 1. Return if already opening a folder
    if (isOpeningFolder) return;
    setState(() {
      isOpeningFolder = true;
    });

    // 2. Fetch folder content from server & Update currentFolder
    final res = await fetchServerAPI("getFolder?folder=$folderPath");
    final body = jsonDecode(res.body);
    final folder = FolderObject.fromMap(body);

    setState(() {
      currentFolder = folder;
      isOpeningFolder = false;
    });
  }

  void onOpenFolder(FolderObject folder) {
    openFolder(folder.folderPath);
  }
  void onBack() {
    openFolder(currentFolder.parent);
  }

  @override
  void initState() {
    openFolder("/");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final showBackFolder = (currentFolder.folderPath != "/");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Row(
            children: [
              SimpleText(text: "Current Folder : '${currentFolder.folderPath}'", scale: 1.4),
            ],
          ),
        ),
        Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: [
            if (showBackFolder) FolderCard(
              folder: const FolderObject.back(),
              onTap: (_) => onBack(),
            ),
            ...currentFolder.folders.map((folder) => FolderCard(
              folder: folder,
              onTap: onOpenFolder,
            )),
            ...currentFolder.files.map((file) => FileCard(
              file: file,
            )),
          ],
        )
      ],
    );
  }
}