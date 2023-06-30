import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String content;
  final VoidCallback function;
  const CustomButton(
      {super.key, required this.content, required this.function});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          )),
      child: Text(
        content,
        style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
