import 'package:diafit/pages/show_library.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Library'),
        ),
        body: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 800),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Book(
                      title: "Diabetes\nMelitus",
                      content: "",
                    ),
                    Book(
                      title: "Diabetes\nInsipidus",
                      content:
                          "Diabetes Melitus, dikenal juga dengan nama kencing manis atau penyakit gula, merupakan penyakit yang terjadi karena tubuh mengalami insufisiensi fungsi insulin sehingga kadar gula dalam darah menjadi tinggi dan tidak dapat dimetabolisme.",
                    ),
                  ],
                ),
                Divider(
                  height: 20,
                  thickness: 10,
                  indent: 35,
                  endIndent: 35,
                  color: Theme.of(context).colorScheme.primary,
                ),
                // const Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Book(title: "Diabetes\nMelitus"),
                //     Book(title: "Diabetes\nInsipidus"),
                //   ],
                // ),
                // Divider(
                //   height: 0,
                //   thickness: 10,
                //   indent: 35,
                //   endIndent: 35,
                //   color: Theme.of(context).colorScheme.primary,
                // ),
                // const Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Book(title: "Diabetes\nMelitus"),
                //     Book(title: "Diabetes\nInsipidus"),
                //   ],
                // ),
              ],
            ),
          ),
        ));
  }
}

class Book extends StatelessWidget {
  final String title;
  final String content;
  const Book({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => PersistentNavBarNavigator.pushNewScreen(context,
          screen: ShowLibrary(
            title: title,
            content: content,
          )),
      child: Container(
        width: 150,
        height: 250,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Book.png"),
          ),
        ),
        child: Text(title),
      ),
    );
  }
}
