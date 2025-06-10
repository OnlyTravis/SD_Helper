import 'dart:convert';

import 'package:client/code/fetch.dart';
import 'package:client/pages/folder_page/page_navigation_buttons.dart';
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
  int currentPage = 0;
  int perPage = 20;
  bool isOpeningFolder = false;
  FolderObject currentFolder = const FolderObject.loading();

  Future<void> openFolder(String folderPath) async {
    // 1. Return if already opening a folder
    if (isOpeningFolder) return;
    setState(() {
      isOpeningFolder = true;
    });

    // 2. Fetch folder content from server & Update currentFolder
    final res = await HttpServer.fetchServerAPI("getFolder?folder=$folderPath");
    final body = jsonDecode(res.body);
    final folder = FolderObject.fromMap(body);

    setState(() {
      currentPage = 0;
      currentFolder = folder;
      isOpeningFolder = false;
    });
  }

  void onOpenFolder(FolderObject folder) {
    openFolder(folder.folderPath);
  }
  void onOpenFile(FileObject file) {
    switch (file.fileType) {
      case FileTypes.Image:
        onOpenImage(file);
        break;
      default:
        break;
    }
  }
  void onOpenImage(FileObject image) {

  }
  void onBack() {
    openFolder(currentFolder.parent);
  }
  void toPage(int pageNum) {
    setState(() {
      currentPage = pageNum;
    });
  }

  @override
  void initState() {
    openFolder("/");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final showBackFolder = (currentFolder.folderPath != "/");
    final folderCount = currentFolder.folders.length;
    final fileCount = currentFolder.files.length;
    final maxPage = ((folderCount + fileCount) / perPage).floor();

    final List<FolderObject> folders = (currentPage*perPage < folderCount) ? currentFolder.folders.sublist(
      currentPage*perPage, 
      ((currentPage+1)*perPage > folderCount) ? folderCount : (currentPage+1)*perPage,
    ) : [];
    final List<FileObject> files = ((currentPage+1)*perPage > folderCount) ? currentFolder.files.sublist(
      (currentPage*perPage-folderCount < 0) ? 0 : currentPage*perPage-folderCount,
      ((currentPage+1)*perPage-folderCount > fileCount) ? fileCount : (currentPage+1)*perPage-folderCount,
    ) : [];

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Row(
                children: [
                  SimpleText("Current Folder : '${currentFolder.folderPath}'", scale: 1.4),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                children: [
                  if (showBackFolder) FolderCard(
                    folder: const FolderObject.back(),
                    onTap: (_) => onBack(),
                  ),
                  ...folders.map((folder) => FolderCard(
                    folder: folder,
                    onTap: onOpenFolder,
                  )),
                  ...files.map((file) => FileCard(
                    folderPath: currentFolder.folderPath,
                    file: file,
                  )),
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: FolderPageNavigationButtons(
            currentPage: currentPage, 
            maxPage: maxPage, 
            toPage: toPage
          ),
        ),
      ],
    );
  }
}