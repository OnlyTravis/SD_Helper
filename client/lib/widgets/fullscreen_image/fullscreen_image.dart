import 'package:client/code/fetch.dart';
import 'package:client/widgets/fullscreen_image/button_group.dart';
import 'package:client/widgets/fullscreen_image/close_button.dart';
import 'package:client/widgets/fullscreen_image/image_name.dart';
import 'package:client/widgets/fullscreen_image/side_button.dart';
import 'package:client/widgets/fullscreen_image/snap_physics.dart';
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

  const FullscreenImage({
    super.key,
    required this.folderPath,
    required this.index,
    required this.imageNames,
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
            onRename: () {},
            onMove: () {},
            onDelete: () {},
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
            onRename: () {},
            onMove: () {},
            onDelete: () {},
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