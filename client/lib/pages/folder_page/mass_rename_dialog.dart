import 'package:flutter/material.dart';

class FolderPageMassRenameDialog extends StatefulWidget {
  final List<String> fileList;
  final Function(String) onConfirm;

  const FolderPageMassRenameDialog({
    super.key,
    required this.fileList,
    required this.onConfirm,
  });

  @override
  State<FolderPageMassRenameDialog> createState() => _FolderPageMassRenameDialogState();
}
// %c(<start>, <length>?, <step>?) e.g. abc_%c(2,4, 2) => abc_0001, abc_0003 ...
class _FolderPageMassRenameDialogState extends State<FolderPageMassRenameDialog> {
  final _controller = TextEditingController();

  bool isValid(String input) {
    // Counter
    final counterRegExp = RegExp(r"/%c\([\s\d,]*\)/g");
    counterRegExp.hasMatch(input);
    
  } 

  String toName(int index) {
    return "wip";
  }

  @override
  Widget build(BuildContext context) {
    final valid = isValid(_controller.text);

    return AlertDialog(
      title: const Text("Mass Rename"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Rename files to : "),
          SizedBox(
            height: 32,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.fileList.asMap().entries.map((entry) => Text("${entry.value} -> ${toName(entry.key)}")).toList(),
              ),
            ),
          ),
          SizedBox(
            width: 256,
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Template for renaming",
              ),
              controller: _controller,
            ),
          ),
        ]
      ),
      actions: [
        TextButton(
          onPressed: valid ? () {
            widget.onConfirm(_controller.text);
          } : null,
          child: const Text('Submit'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}