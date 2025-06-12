import 'dart:convert';

import 'package:client/code/dialog.dart';
import 'package:client/code/fetch.dart';
import 'package:client/pages/fullscreen_image/button_group.dart';
import 'package:client/pages/fullscreen_image/close_button.dart';
import 'package:client/pages/fullscreen_image/image_name.dart';
import 'package:client/pages/fullscreen_image/side_button.dart';
import 'package:client/pages/fullscreen_image/snap_physics.dart';
import 'package:client/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

class _FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const _FullScreenImage({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(90, 124, 124, 124),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}

class FullscreenImage extends StatefulWidget {
  final String folderPath;
  final int index;
  final List<String> imageNames;
  final VoidCallback onUpdate;

  const FullscreenImage({
    super.key,
    required this.folderPath,
    required this.index,
    required this.imageNames,
    required this.onUpdate,
  });

  @override
  State<FullscreenImage> createState() => _FullscreenImageState();
}
class _FullscreenImageState extends State<FullscreenImage> {
  late final PageController _pageController;
  late int _currentIndex;
  bool _buttonsShown = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _pageController = PageController(initialPage: widget.index);
      _currentIndex = widget.index;
    });
  }

  void _onChangeImage(int offset) {
    setState(() {
      _currentIndex = _currentIndex + offset;
    });
  }
  void _onExit() {
    Navigator.of(context).pop();
  }
  void _onRename() async {
    // 1. Input new name
    final newName = await alertInput<String>(
      context, 
      title: "Rename Image",
      text: "Enter new name of image : ",
    );
    if (newName == null || newName.isEmpty) {
      if (mounted) alert(context, text: "Invalid new name.");
      return;
    }

    // 2. Check if image with new name already exist
    final fileExtension = widget.imageNames[_currentIndex].split(".").last;
    final newFileName = "$newName.$fileExtension";
    if (widget.imageNames.contains(newFileName)) {
      if (mounted) alert(context, text: "An image with that name already exist!");
      return;
    }

    // 3. Send request
    final imageName = widget.imageNames[_currentIndex];
    try {
      HttpServer.postServerAPI("renameImage", {
        "image": "${widget.folderPath}/$imageName",
        "newName": newName,
      });
    } catch (err) {
      if (mounted) alert(context, text: "Something went wrong while renaming image! ErrorText: ($err)");
      return;
    }

    // 4. Call update on parent
    widget.onUpdate();
    if (mounted) alertSnackbar(context, text: "Image '$imageName' Renamed to $newFileName!");
    setState(() {
      widget.imageNames[_currentIndex] = newFileName;
    });
  }
  void _onMove() async {

  }
  void _onDelete() async {
    // 1. Confirm Delete
    final ans = await confirm(context, title: "Confirm Delete", text: "Are you sure you want to delete this image?");
    if (!ans) return;

    // 2. Send Delete Request
    final imageName = widget.imageNames[_currentIndex];
    try {
      HttpServer.postServerAPI("deleteImages", {
        "images": jsonEncode(["${widget.folderPath}/$imageName"]),
      });
    } catch (err) {
      if (mounted) alert(context, text: "Something went wrong while requesting to delete image! ErrorText: ($err)");
      return;
    }

    // 3. Move to adjacent image, if none => exit
    bool exitPage = false;
    if (_currentIndex < widget.imageNames.length-1) {
      _onChangeImage(1);
    } else if (_currentIndex > 0) {
      _onChangeImage(-1);
    } else {
      exitPage = true;
    }

    // 4. Call update on parent
    widget.onUpdate();
    if (mounted) alertSnackbar(context, text: "Image '$imageName' Deleted!");
    if (exitPage && mounted) _onExit();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = HttpServer.imageUrl("${widget.folderPath}/${widget.imageNames[_currentIndex]}", false);
    return ResponsiveLayout(
      mobileBody: _mobileUI(imageUrl),
      desktopBody: _desktopUI(imageUrl),
    );
  }
  Widget _mobileUI(String imageUrl) {
    return GestureDetector(
      onTap: () => setState(() {_buttonsShown = !_buttonsShown;}),
      child: Stack(
        children: [
          PageView.builder(
            physics: const FullscreenImageSnapPhysics(),
            controller: _pageController,
            itemBuilder: (context, index) {
              final i = index % widget.imageNames.length;
              final url = HttpServer.imageUrl("${widget.folderPath}/${widget.imageNames[i]}", false);
              return _FullScreenImage(
                imageUrl: url,
              );
            }
          ),
          FullscreenImageCloseButton(visible: _buttonsShown, onTap: _onExit),
          FullscreenImageButtonGroup(
            visible: _buttonsShown,
            onRename: _onRename,
            onMove: _onMove,
            onDelete: _onDelete,
          ),
          FullscreenImageName(
            visible: _buttonsShown, 
            imageName: Text(widget.imageNames[_currentIndex]),
          ),
        ],
      ),
    );
  }

  Widget _desktopUI(String imageUrl) {
    return GestureDetector(
      onTap: _onExit,
      child: Stack(
        children: [
          _FullScreenImage(imageUrl: imageUrl),
          (_currentIndex > 0) ? FullscreenImageSideButton(
            align: Alignment.topLeft, 
            icon: Icons.arrow_left,
            onTap: () => _onChangeImage(-1),
          ) : const SizedBox.shrink(),
          if (_currentIndex < widget.imageNames.length-1) FullscreenImageSideButton(
            align: Alignment.topRight, 
            icon: Icons.arrow_right,
            onTap: () => _onChangeImage(1),
          ),
          FullscreenImageButtonGroup(
            visible: _buttonsShown,
            onRename: _onRename,
            onMove: _onMove,
            onDelete: _onDelete,
          ),
          FullscreenImageName(
            visible: _buttonsShown, 
            imageName: Text(widget.imageNames[_currentIndex]),
          ),
        ],
      ),
    );
  }
}