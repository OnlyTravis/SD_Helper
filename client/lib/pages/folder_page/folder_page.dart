import 'dart:convert';

import 'package:client/code/fetch.dart';
import 'package:client/pages/folder_page/top_bar.dart';
import 'package:client/pages/fullscreen_image/fullscreen_image.dart';
import 'package:client/pages/folder_page/page_navigation_buttons.dart';
import 'package:client/widgets/file_card.dart';
import 'package:client/widgets/folder_card.dart';
import 'package:client/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

enum DisplayStyle {
  SmallIcon,
  MediumIcon,
  LargeIcon,
  List,
}
class _SelectedItem {
  final String folderPath;
  final String fileName;
  
  const _SelectedItem({
    required this.folderPath,
    required this.fileName,
  });
}
class FolderPage extends StatefulWidget {
  const FolderPage({super.key});

  @override
  State<FolderPage> createState() => _FolderPageState();
}
class _FolderPageState extends State<FolderPage> {
  static int _currentPage = 0;
  static DisplayStyle _displayStyle = DisplayStyle.LargeIcon;

  static bool _isOpeningFolder = false;
  static FolderObject _currentFolder = const FolderObject.loading();
  static List<String> _imageNames = [];

  static List<_SelectedItem> _selected = [];

  Future<void> openFolder(String folderPath) async {
    // 1. Return if already opening a folder
    if (_isOpeningFolder) return;
    setState(() {
      _isOpeningFolder = true;
    });

    // 2. Fetch folder content from server & Update _currentFolder
    final res = await HttpServer.fetchServerAPI("getFolder?folder=$folderPath");
    final body = jsonDecode(res.body);
    final folder = FolderObject.fromMap(body);

    setState(() {
      _currentPage = 0;
      _currentFolder = folder;
      _imageNames = folder.files.where((file) => file.fileType == FileTypes.Image).map((img) => img.fileName).toList();
      _isOpeningFolder = false;
    });
  }
  Future<void> updateFolder() async {
    if (_isOpeningFolder) return;
    setState(() {
      _isOpeningFolder = true;
    });

    final res = await HttpServer.fetchServerAPI("getFolder?folder=${_currentFolder.folderPath}");
    final body = jsonDecode(res.body);
    final folder = FolderObject.fromMap(body);

    setState(() {
      _currentFolder = folder;
      _imageNames = folder.files.where((file) => file.fileType == FileTypes.Image).map((img) => img.fileName).toList();
      _isOpeningFolder = false;
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
  Future<void> onOpenImage(FileObject image) async {
    final index = _imageNames.indexOf(image.fileName);
    await showDialog(
      context: context, 
      builder: (_) => FullscreenImage(
        folderPath: _currentFolder.folderPath,
        index: index,
        imageNames: _imageNames, 
        onUpdate: updateFolder,
      ),
    );
  }

  void onBack() {
    openFolder(_currentFolder.parent);
  }
  void toPage(int pageNum) {
    setState(() {
      _currentPage = pageNum;
    });
  }

  void onFileTap(FileObject file) {
    if (_selected.isEmpty) {
      onOpenFile(file);
      return;
    }
    onFileSelect(file);
  }
  void onFileSelect(FileObject file) {
    final index = _selected.indexWhere((selected) => selected.fileName == file.fileName && selected.folderPath == _currentFolder.folderPath);
    if (index == -1) {
      // Select File
      setState(() {
        _selected.add(_SelectedItem(
          folderPath: _currentFolder.folderPath, 
          fileName: file.fileName,
        ));
      });
      return;
    }
    // Deselect file
    setState(() {
      _selected.removeAt(index);
    });
  }

  // Get itemPerPage based on display style & (Desktop or Mobile)
  int getPerPage(DisplayStyle style) {
    final bool isDesktop = isWideScreen(context);
    int perPage = 5;
    switch (style) {
      case DisplayStyle.LargeIcon:
        perPage = isDesktop ? 20 : 10;
        break;
      default:
        break;
    }
    return perPage;
  }

  @override
  void initState() {
    super.initState();
    if (_currentFolder == const FolderObject.loading()) {
        openFolder("/");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: _pageBody());
  }
  Widget _pageBody() {
    // 1. Files / Folders display
    final perPage = getPerPage(_displayStyle);
    final showBackFolder = (_currentFolder.folderPath != "/");
    final folderCount = _currentFolder.folders.length;
    final fileCount = _currentFolder.files.length;
    final maxPage = ((folderCount + fileCount) / perPage).floor();
    if (_currentPage > maxPage) setState(() {
      _currentPage = maxPage;
    });
    final selectedCount = _selected.length;

    final List<FolderObject> folders = (_currentPage*perPage < folderCount) ? _currentFolder.folders.sublist(
      _currentPage*perPage, 
      ((_currentPage+1)*perPage > folderCount) ? folderCount : (_currentPage+1)*perPage,
    ) : [];
    final List<FileObject> files = ((_currentPage+1)*perPage > folderCount) ? _currentFolder.files.sublist(
      (_currentPage*perPage-folderCount < 0) ? 0 : _currentPage*perPage-folderCount,
      ((_currentPage+1)*perPage-folderCount > fileCount) ? fileCount : (_currentPage+1)*perPage-folderCount,
    ) : [];

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FolderPageTopBar(
                folderPath: _currentFolder.folderPath,
                selectedCount: selectedCount,
              ),
              Wrap(
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
                    folderPath: _currentFolder.folderPath,
                    file: file,
                    onTap: onFileTap,
                    onLongPress: onFileSelect,
                  )),
                ],
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: FolderPageNavigationButtons(
            currentPage: _currentPage, 
            maxPage: maxPage, 
            toPage: toPage
          ),
        ),
      ],
    );
  }
}