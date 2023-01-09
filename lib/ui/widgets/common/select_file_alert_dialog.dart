import 'package:flutter/material.dart';

class SelectFileAlertDialog extends StatelessWidget {
  const SelectFileAlertDialog({
    super.key,
    required this.onTakeImageButtonPressed,
    required this.onSelectImageButtonPressed,
  });

  final Function() onTakeImageButtonPressed;
  final Function() onSelectImageButtonPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text(
        'Select image for post',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: <Widget>[
        TextButton(
          onPressed: onSelectImageButtonPressed,
          child: const Text('Select file'),
        ),
        TextButton(
          onPressed: onTakeImageButtonPressed,
          child: const Text('Take a photo'),
        ),
      ],
    );
  }
}
