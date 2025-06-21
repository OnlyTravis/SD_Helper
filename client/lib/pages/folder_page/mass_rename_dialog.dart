import 'package:client/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class FolderPageMassRenameDialog extends StatefulWidget {
  final List<String> fileList;
  final List<String> otherFiles;
  final Function(String) onConfirm;

  const FolderPageMassRenameDialog({
    super.key,
    required this.fileList,
    required this.otherFiles,
    required this.onConfirm,
  });

  @override
  State<FolderPageMassRenameDialog> createState() => _FolderPageMassRenameDialogState();
}
// %c(<start>, <length>?, <step>?) e.g. abc_%c(2,4, 2) => abc_0001, abc_0003 ...
class _FolderPageMassRenameDialogState extends State<FolderPageMassRenameDialog> {
  final _controller = TextEditingController();
	String input = "";
	String errorText = "";

  bool isValid() {
    bool valid = true;

    // Check for Counter
    final counterRegExp = RegExp(r"%c\((?<params>[\s\d,]*)\)");
    final matches = counterRegExp.allMatches(input);
    
		if (matches.isEmpty) {
			setState(() {
				errorText = "Atleast 1 counter must present when mass renaming files to avoid same file names!";
			});
			valid = false;
		}
		for (final match in matches) {
			final params = match.namedGroup("params")!.split(",").map((param) => int.tryParse(param));
			if (params.isEmpty || params.contains(null) || params.length > 3) {
				setState(() {
				  errorText = "Invalid Counter at position ${match.start} : '${match.group(0)}'. ";
				});
				valid = false;
			}
		}

		setState(() {
		  errorText = "";
		});
		return valid;
  } 

  List<String> getNewNames() {
    final newNames = List.filled(widget.fileList.length, input); 

    // handle counters
    final counterRegExp = RegExp(r"%c\((?<params>[\s\d,]*)\)");
    for (final match in counterRegExp.allMatches(input)) {
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

    // Add file extensions
    for (int i = 0; i < newNames.length; i++) {
      newNames[i] += ".${widget.fileList[i].split(".").last}";
    }
    return newNames;
  }

  @override
  Widget build(BuildContext context) {
    final valid = isValid();
		final newNames = getNewNames();

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
                children: widget.fileList.asMap().entries.map((entry) => Text("${entry.value} -> ${newNames[entry.key]}")).toList(),
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
							onChanged: (value) => setState(() { input = value; }),
              controller: _controller,
            ),
          ),
					if (errorText.isNotEmpty) SimpleText("*$errorText", color: Colors.red),
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