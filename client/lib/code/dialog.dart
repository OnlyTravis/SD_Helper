import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool> confirm(BuildContext context, {
	String title = "",
	String text = "",
}) async {
	bool confirmed = false;
	await showDialog(
		context: context,
		builder: (BuildContext context) => AlertDialog(
			title: Text(title),
			content: Text(text),
			actions: [
				TextButton(
					onPressed: () {
						confirmed = true;
						Navigator.pop(context);
					},
					child: const Text('Confirm'),
				),
				TextButton(
					onPressed: () {
						Navigator.pop(context);
					},
					child: const Text('Cancel'),
				),
			],
		),
	);
	return confirmed;
}

void alertSnackbar(BuildContext context, {
	String text = "",
	int duration = 1,
}) {
	final snackBar = SnackBar(
		content: Text(text),
		duration: Duration(seconds: duration),
		action: SnackBarAction(
			label: "Dismiss", 
			onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar
		),
	);
	ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<T?> alertInput<T>(BuildContext context, {
	required String title,
	String text = "",
	String? placeHolder,
	String? defaultValue,
}) async {
	late TextInputType keyboardType;
	List<TextInputFormatter> inputFormatters = [];
	switch (T) {
		case String: 
			keyboardType = TextInputType.text;
			break;
		case int:
			keyboardType = const TextInputType.numberWithOptions(decimal: false);
			inputFormatters.add(FilteringTextInputFormatter.digitsOnly);
			break;
		case double:
			keyboardType = TextInputType.number;
			break;
		default: throw Exception("Type parameter in alertInput must of type 'int', 'double' or 'String'.");
	}

	String? responceText;
	TextEditingController controller = TextEditingController(text: defaultValue);
	await showDialog(
		context: context,
		builder: (BuildContext context) => AlertDialog(
			title: Text(title),
			content: Wrap(
				direction: Axis.vertical,
				children: [
					if (text.isNotEmpty) Text(text),
					SizedBox(
						width: 256,
						child: TextField(
							decoration: InputDecoration(
								border: const OutlineInputBorder(),
								labelText: placeHolder,
							),
							inputFormatters: inputFormatters,
							keyboardType: keyboardType,
							controller: controller,
						),
					)
				],
			),
			actions: [
				TextButton(
					onPressed: () {
						responceText = controller.text;
						Navigator.pop(context);
					},
					child: const Text('Submit'),
				),
				TextButton(
					onPressed: () {
						Navigator.pop(context);
					},
					child: const Text('Cancel'),
				),
			],
		),
	);

	if (responceText == null) return null;

	switch (T) {
		case String: return responceText as T;
		case int: return int.tryParse(responceText ?? "") as T;
		case double: return double.tryParse(responceText ?? "") as T;
		default: throw Exception("Type parameter in alertInput must of type 'int', 'double' or 'String'.");
	}
}