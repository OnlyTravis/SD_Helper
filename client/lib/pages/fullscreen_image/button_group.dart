import 'package:client/widgets/responsive_layout.dart';
import 'package:client/widgets/text_icon_button.dart';
import 'package:flutter/material.dart';

class FullscreenImageButtonGroup extends StatelessWidget {
  final bool visible;
  final VoidCallback onRename;
  final VoidCallback onMove;
  final VoidCallback onDelete;

  const FullscreenImageButtonGroup({
    super.key,
    required this.visible,
    required this.onRename,
    required this.onMove,
    required this.onDelete,
  });

  Widget _buttonGroupBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 80,
            child: TextIconButton(
              onTap: onRename, 
              icon: const Icon(Icons.drive_file_rename_outline), 
              text: const Text("Rename")
            ),
          ),
          SizedBox(
            width: 80,
            child: TextIconButton(
              onTap: onMove, 
              icon: const ImageIcon(AssetImage("icons/file_move.png")), 
              text: const Text("Move")
            ),
          ),
          SizedBox(
            width: 80,
            child: TextIconButton(
              onTap: onDelete, 
              icon: const Icon(Icons.delete), 
              text: const Text("Delete")
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: AnimatedPositioned(
        right: 16,
        bottom: visible ? 16 : -80,
        duration: const Duration(milliseconds: 100),
        child: _buttonGroupBody(context), 
      ), 
      desktopBody: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buttonGroupBody(context),
        ),
      ),
    );
  }
}