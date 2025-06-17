import 'dart:convert';

import 'package:client/code/dialog.dart';
import 'package:client/code/fetch.dart';
import 'package:client/pages/folder_page/action_button_group.dart';
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

class FolderPage extends StatefulWidget {
  const FolderPage({super.key});

  @override
  State<FolderPage> createState() => _FolderPageState();
}
class _FolderPageState extends State<FolderPage> {
  static int _currentPage = 0;
  static final DisplayStyle _displayStyle = DisplayStyle.LargeIcon;

  static bool _isOpeningFolder = false;
  static FolderObject _currentFolder = const FolderObject.loading();
  static List<String> _imageNames = [];

  static List<bool> _isSelected = [];
  static int _selectFileCount = 0;
  static int _selectFolderCount = 0;

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
      _isSelected = List.filled(folder.files.length + folder.folders.length, false);
      _selectFileCount = 0;
      _selectFolderCount = 0;
      _imageNames = folder.files.where((file) => file.fileType == FileTypes.Image).map((img) => img.fileName).toList();
      _isOpeningFolder = false;
    });
  }
  void onFolderTap(FolderObject folder) {
    if (_selectFileCount + _selectFolderCount == 0) {
      openFolder(folder.folderPath);
      return;
    }
    onFolderSelect(folder);
  }
  void onFolderSelect(FolderObject folder) {
    final folderIndex = _currentFolder.folders.indexOf(folder);
    if (folderIndex == -1) return;

    setState(() {
      if (_isSelected[folderIndex]) {
        _isSelected[folderIndex] = false;
        _selectFolderCount--;
      } else {
        _isSelected[folderIndex] = true;
        _selectFolderCount++;
      }
    });
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
    if (_selectFileCount + _selectFolderCount == 0) {
      onOpenFile(file);
      return;
    }
    onFileSelect(file);
  }
  void onFileSelect(FileObject file) {
    final folderCount = _currentFolder.folders.length;
    final fileIndex = _currentFolder.files.indexOf(file);
    if (fileIndex == -1) return;

    setState(() {
      if (_isSelected[fileIndex + folderCount]) {
        _isSelected[fileIndex + folderCount] = false;
        _selectFileCount--;
      } else {
        _isSelected[fileIndex + folderCount] = true;
        _selectFileCount++;
      }
    });
  }
  void _deselectAll() {
    setState(() {
      _isSelected = List.filled(_currentFolder.files.length + _currentFolder.folders.length, false);
      _selectFileCount = 0;
      _selectFolderCount = 0;
    });
  }

  void _onRenameFile() async {
    // 1. Input new name
    final selectedFile = _currentFolder.files[_isSelected.lastIndexOf(true) - _currentFolder.folders.length];
    final newName = await alertInput<String>(
      context, 
      title: "Rename File",
      text: "Rename file (${selectedFile.fileName}) \nto : (file extensions not needed) ",
    );
    if (newName == null || newName.isEmpty) {
      if (mounted) alert(context, title: "Error", text: "Invalid name.");
      return;
    }

    // 2. Check if image with new name already exist
    final fileExtension = selectedFile.fileName.split(".").last;
    final newFileName = "$newName.$fileExtension";
    if (_currentFolder.files.indexWhere((file) => file.fileName == newFileName) != -1) {
      if (mounted) alert(context, title: "Error", text: "A file with that name already exist!");
      return;
    }

    // 3. Send request
    try {
      final res = await HttpServer.postServerAPI("renameFile", {
        "file": "${_currentFolder.folderPath}/${selectedFile.fileName}",
        "newName": newName,
      });
      if (res.statusCode != 200) {
        if (mounted) alert(context, title: "Error", text: "Something went wrong while renaming the file! Responce: '${res.body}'");
        return;
      }
    } catch (err) {
      if (mounted) alert(context, title: "Error", text: "Something went wrong while renaming the file! ErrorText: ($err)");
      return;
    }

    // 4. Call update on parent
    updateFolder();
    _deselectAll();
    if (mounted) alertSnackbar(context, text: "File '${selectedFile.fileName}' Renamed to $newFileName!");
  }
  void _onMassRenameFile() async {
    // 1. Input new name
    final selectedFile = _currentFolder.files[_isSelected.lastIndexOf(true) - _currentFolder.folders.length];
    final newName = await alertInput<String>(
      context, 
      title: "Mass Rename File",
      text: "Mass Rename files to : (file extensions not needed) ",
    );
    if (newName == null || newName.isEmpty) {
      if (mounted) alert(context, title: "Error", text: "Invalid name.");
      return;
    }
  }
  void _onRenameFolder() async {
    // 1. Input new name
    final selectedFolder = _currentFolder.folders[_isSelected.indexOf(true)];
    final newName = await alertInput<String>(
      context, 
      title: "Rename Folder",
      text: "Rename folder (${selectedFolder.folderName}) \nto : ",
    );
    if (newName == null || newName.isEmpty) {
      if (mounted) alert(context, title: "Error", text: "Invalid name.");
      return;
    }

    // 2. Check if folder with new name already exist
    if (_currentFolder.folders.indexWhere((folder) => folder.folderName == newName) != -1) {
      if (mounted) alert(context, title: "Error", text: "A folder with that name already exist!");
      return;
    }

    // 3. Send request
    try {
      final res = await HttpServer.postServerAPI("renameFolder", {
        "folder": selectedFolder.folderPath,
        "newName": newName,
      });
      if (res.statusCode != 200) {
        if (mounted) alert(context, title: "Error", text: "Something went wrong while renaming the folder! Responce: '${res.body}'");
        return;
      }
    } catch (err) {
      if (mounted) alert(context, title: "Error", text: "Something went wrong while renaming the folder! ErrorText: ($err)");
      return;
    }

    // 4. Call update on parent
    updateFolder();
    _deselectAll();
    if (mounted) alertSnackbar(context, text: "Folder '${selectedFolder.folderName}' Renamed to $newName!");
  }
  void _onDelete() async {
    // 1. Get selected files / folders;
    final folderCount = _currentFolder.folders.length;
    final files = _currentFolder.files.asMap().entries.where((entry) => _isSelected[entry.key + folderCount]).map((entry) => entry.value).toList();
    final folders = _currentFolder.folders.asMap().entries.where((entry) => _isSelected[entry.key]).map((entry) => entry.value).toList();

    // 2. Confirm delete
    late String titleText;
    if (_selectFileCount == 1 && _selectFolderCount == 0) {
      titleText = "Are you sure you want to delete this file?";
    } else if (_selectFolderCount == 1 && _selectFileCount == 0) {
      titleText = "Are you sure you want to delete this folder?";
    } else if (_selectFolderCount == 0) {
      titleText = "Are you sure you want to delete these files?";
    } else if (_selectFileCount == 0) {
      titleText = "Are you sure you want to delete these folders?";
    } else {
      titleText = "Are you sure you want to delete these files & folders?";
    }
    final confirmDelete = await confirm(
      context, 
      title: titleText, 
      text: "${folders.map((folder) => "${folder.folderName}/").join("\n")}${files.map((file) => file.fileName).join("\n")}",
    );
    if (!confirmDelete) return;
    
    // 3. Send delete request to server
    try {
      final folderPath = _currentFolder.folderPath;
      final res = await HttpServer.postServerAPI("deleteFiles", {
        "files": jsonEncode(files.map((file) => "$folderPath/${file.fileName}").toList()),
        "folders": jsonEncode(folders.map((folder) => folder.folderPath).toList()),
      });
      if (res.statusCode != 200) {
        if (mounted) alert(context, text: "Something went wrong while deleting objects! Responce: '${res.body}'");
        return;
      }
    } catch (err) {
      if (mounted) alert(context, text: "Something went wrong while deleting objects! ErrorText: ($err)");
      return;
    }

    // 4. Call update on parent
    updateFolder();
    _deselectAll();
    if (mounted) alertSnackbar(context, text: "Files Deleted!");
  }

  // Get itemPerPage based on display style & (Desktop or Mobile)
  int _getPerPage(DisplayStyle style) {
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
    final perPage = _getPerPage(_displayStyle);
    final showBackFolder = (_currentFolder.folderPath != "/");
    final folderCount = _currentFolder.folders.length;
    final fileCount = _currentFolder.files.length;
    final maxPage = ((folderCount + fileCount) / perPage).floor();
    if (_currentPage > maxPage) setState(() {
      _currentPage = maxPage;
    });

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
                selectedCount: _selectFileCount + _selectFolderCount,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.start,
                  children: [
                    if (showBackFolder) FolderCard(
                      folder: const FolderObject.back(),
                      onTap: (_) => onBack(),
                    ),
                    ...folders.asMap().entries.map((entry) => FolderCard(
                      folder: entry.value,
                      isSelected: _isSelected[entry.key],
                      onTap: onFolderTap,
                      onLongPress: onFolderSelect,
                    )),
                    ...files.asMap().entries.map((entry) => FileCard(
                      folderPath: _currentFolder.folderPath,
                      file: entry.value,
                      isSelected: _isSelected[entry.key + folderCount],
                      onTap: onFileTap,
                      onLongPress: onFileSelect,
                    )),
                  ],
                ),
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
        FolderPageActionButtonGroup(
          isEditing: (_selectFileCount + _selectFolderCount > 0),
          fileOnly: (_selectFolderCount == 0),
          folderOnly: (_selectFileCount == 0),
          singleFile: (_selectFileCount == 1),
          singleFolder: (_selectFolderCount == 1),
          onRenameFile: _onRenameFile,
          onMassRenameFiles: () {},
          onRenameFolder: _onRenameFolder,
          onMove: () {},
          onDelete: _onDelete,
        ),
      ],
    );
  }
}