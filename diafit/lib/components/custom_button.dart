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
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF757DF0)),
      child: Text(
        content,
      ),
    );
  }
}
