import 'package:flutter/material.dart';
// import 'package:diafit/Tracker/exercise_tracker.dart';
// import 'package:diafit/Tracker/glucose_tracker.dart';
// import 'package:diafit/Tracker/nutrition_tracker.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Tracker extends StatefulWidget {
  const Tracker({super.key});

  @override
  State<Tracker> createState() => TrackerState();
}

class TrackerState extends State<Tracker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracker'),
      ),
      body: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Placeholder(
                fallbackHeight: 200,
                fallbackWidth: 200,
                color: Colors.blue,
              ),
              Placeholder(
                fallbackHeight: 200,
                fallbackWidth: 200,
                color: Colors.blue,
              ),
              Placeholder(
                fallbackHeight: 200,
                fallbackWidth: 200,
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TrackerCard extends StatelessWidget {
  final String content;
  final Widget page;
  final Icon icon;
  final String routeName;

  const TrackerCard(
      {super.key,
      required this.content,
      required this.page,
      required this.icon,
      required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 1,
      color: const Color(0xFF3641B7),
      child: InkWell(
        onTap: () {
          Placeholder(
            fallbackHeight: 200,
            fallbackWidth: 200,
            color: Colors.blue,
          );
        },
        child: SizedBox(
          width: 300,
          height: 100,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(
                  width: 20,
                ),
                Text(
                  content,
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
