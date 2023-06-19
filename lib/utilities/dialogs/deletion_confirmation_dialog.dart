import 'package:flutter/cupertino.dart';
import 'package:metapp/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeletionConfirmationDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Delete',
    content: 'Are You Sure You Want To Delete?',
    optionsBuilder: () => {
      'Cancel' : false,
      'Yes' : true,
    },
  ).then((value) => value ?? false);
}
