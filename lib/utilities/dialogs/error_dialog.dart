import 'package:flutter/material.dart';
import 'package:metapp/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
    context: context,
    title: 'An error has occured',
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
