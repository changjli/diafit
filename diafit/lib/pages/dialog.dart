import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final bool status;
  const MyDialog({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Alert'),
      content: status == true ? const Text('success') : const Text('error'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
