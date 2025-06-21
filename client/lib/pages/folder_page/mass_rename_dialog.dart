import 'package:client/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class FolderPageMassRenameDialog extends StatefulWidget {
  final List<String> fileList;
  final List<String> allFiles;
  final Function(List<String>) onConfirm;

  const FolderPageMassRenameDialog({
    super.key,
    required this.fileList,
    required this.allFiles,
    required this.onConfirm,
  });

  @override
  State<FolderPageMassRenameDialog> createState() => _FolderPageMassRenameDialogState();
}
// %c(<start>, <length>?, <step>?) e.g. abc_%c(2,4, 2) => abc_0001, abc_0003 ...
class _FolderPageMassRenameDialogState extends State<FolderPageMassRenameDialog> {
  final _controller = TextEditingController();
  late final List<String> otherFiles;

  bool valid = false;
  String errorText = "";
  List<String> newTexts = [];

  bool isValid(List<String> newNames) {
    bool isValid_ = true;
    String newErrorText = "";

    // 1. Check if Number Counter exist
    final counterRegExp = RegExp(r"%c\((?<params>[\s\d,]*)\)");
    final matches = counterRegExp.allMatches(_controller.text);
    
    if (matches.isEmpty) {
      newErrorText += "Atleast 1 counter must present when mass renaming files to avoid same file names!\n";
      isValid_ = false;
    }
    for (final match in matches) {
      final params = match.namedGroup("params")!.split(",").map((param) => int.tryParse(param));
      if (params.isEmpty || params.contains(null) || params.length > 3) {
        newErrorText += "Invalid Counter at position ${match.start} : '${match.group(0)}'.\n";
        isValid_ = false;
      }
    }

    // 2. Check for name collision
    for (final name in newNames) {
      if (!otherFiles.contains(name)) continue;

      newErrorText += "Name '$name' already exists in current folder!\n";
      isValid_ = false;
      break;
    }

    setState(() {
      errorText = newErrorText;
    });
    return isValid_;
  } 

  List<String> getNewNames() {
    final newNames = List.filled(widget.fileList.length, _controller.text); 

    // 1. Handle counters
    final counterRegExp = RegExp(r"%c\((?<params>[\s\d,]*)\)");
    for (final match in counterRegExp.allMatches(_controller.text)) {
      final params = match.namedGroup("params")!.split(",").map((param) => int.tryParse(param)).toList();
      if (params.isEmpty || params.contains(null) || params.length > 3) continue;
      final int start = params[0] ?? 0;
      final int length = params.elementAtOrNull(1) ?? -1;
      final int step = params.elementAtOrNull(2) ?? 1;

      if (length == -1) {
        for (int i = 0; i < newNames.length; i++) {
          final replaceString = (start+step*i).toString();
          newNames[i] = newNames[i].replaceAll(match.group(0) ?? "", replaceString);
        }
      } else {
        for (int i = 0; i < newNames.length; i++) {
          final replaceString = (start+step*i).toString().padLeft(length, "0");
          newNames[i] = newNames[i].replaceAll(match.group(0) ?? "", replaceString);
        }
      }
    }

    // 2. Add file extensions
    for (int i = 0; i < newNames.length; i++) {
      newNames[i] += ".${widget.fileList[i].split(".").last}";
    }
    return newNames;
  }

  void onChange(_) {
    final names = getNewNames();
    final isValid_ = isValid(names);
    setState(() {
      newTexts = names;
      valid = isValid_;
    });
  }

  @override
  void initState() {
    otherFiles = widget.allFiles.where((file) => !widget.fileList.contains(file)).toList();
    onChange("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Mass Rename"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SimpleText("Rename files to : ", scale: 1.2),
          Container(
            width: 512,
            constraints: const BoxConstraints(
              maxHeight: 64
            ),
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 215, 215, 215),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.fileList.asMap().entries.map((entry) => Text("${entry.value} -> ${newTexts[entry.key]}")).toList(),
              ),
            ),
          ),
          SizedBox(
            width: 512,
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Template for renaming",
              ),
              onChanged: onChange,
              controller: _controller,
            ),
          ),
          const Text("Counter: %c(start, length?, step?)"),
          if (errorText.isNotEmpty) SimpleText("*$errorText", color: Colors.red),
        ],
      ),
      actions: [
        TextButton(
          onPressed: valid ? () {
            Navigator.pop(context);
            widget.onConfirm(newTexts);
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