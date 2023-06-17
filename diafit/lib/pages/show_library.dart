import 'package:flutter/material.dart';

class ShowLibrary extends StatelessWidget {
  final String title;
  final String content;
  const ShowLibrary({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(title),
          Text(content),
        ],
      ),
    );
  }
}
