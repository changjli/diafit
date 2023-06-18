import 'package:flutter/material.dart';

class ShowLibrary extends StatelessWidget {
  final String title;
  final String content;
  final String image;
  const ShowLibrary(
      {super.key,
      required this.title,
      required this.content,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            color: Theme.of(context).colorScheme.secondary,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Book2.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 200,
                      width: 300,
                      child: Image.asset(image),
                    ),
                    Text(title),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(content),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
