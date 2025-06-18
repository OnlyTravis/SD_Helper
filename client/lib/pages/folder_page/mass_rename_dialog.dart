import 'package:client/widgets/custom_text.dart';
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
	String input = "";
	String errorText = "";

  bool isValid() {
    // Check for Counter
    final counterRegExp = RegExp(r"%c\((?<params>[\s\d,]*)\)");
    final matches = counterRegExp.allMatches(input);
    
		if (matches.isEmpty) {
			setState(() {
				errorText = "Atleast 1 counter must present when mass renaming files to avoid same file names!";
			});
			return false;
		}
		for (final match in matches) {
			final params = match.namedGroup("params")!.split(",").map((param) => int.tryParse(param));
			if (params.contains(null) || params.length > 3) {
				setState(() {
				  errorText = "Invalid Counter at position ${match.start} : '${match.group(0)}'. ";
				});
				return false;
			}
		}

		setState(() {
		  errorText = "";
		});
		return true;
  } 

  List<String> getNewNames() {
		
    return ["wip"];
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