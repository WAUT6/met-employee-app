import 'package:flutter/material.dart';
import 'package:metapp/utilities/dialogs/generic_dialog.dart';

Future<T?> showTextFieldDialog<T>({
  required BuildContext context,
  required String title,
  required DialogOptionalBuilder optionsBuilder,
  required TextEditingController controller,
}) {
  final options = optionsBuilder();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          cursorColor: Colors.black,
          controller: controller,
          autofocus: true,
        ),
        actions: options.keys.map(
          (optionsTitle) {
            final value = options[optionsTitle];
            return TextButton(
              onPressed: () {
                if (value != null) {
                  Navigator.of(context).pop(value);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                optionsTitle,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          },
        ).toList(),
      );
    },
  );
}
