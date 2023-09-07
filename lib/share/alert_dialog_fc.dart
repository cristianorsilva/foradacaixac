import 'package:flutter/material.dart';

Future<void> showAlertDialog(String title, String message, BuildContext context, String titleKey, String messageKey, String buttonKey) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title, key: Key(titleKey), style: Theme.of(context).textTheme.displaySmall),
        content: Text(message, key: Key(messageKey), style: Theme.of(context).textTheme.bodyLarge),
        elevation: 2.0,
        actions: [
          TextButton(
              key: Key(buttonKey),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK')),
        ],
      );
    },
  );
}
