import 'package:diafit/pages/Tracker/exercise_tracker.dart';
import 'package:diafit/pages/Tracker/glucose_tracker.dart';
import 'package:diafit/pages/Tracker/nutrition_tracker.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Tracker extends StatefulWidget {
  const Tracker({super.key});

  @override
  State<Tracker> createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracker'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: const [
              TrackerCard(
                content: 'Glucose Tracker',
                page: GlucoseTracker(),
                icon: Icon(Icons.track_changes),
                routeName: 'GlucoseTracker',
              ),
              TrackerCard(
                content: 'Nutrition Tracker',
                page: NutritionTracker(),
                icon: Icon(Icons.food_bank),
                routeName: 'NutritionTracker',
              ),
              TrackerCard(
                content: 'Exercise Tracker',
                page: ExerciseTracker(),
                icon: Icon(Icons.assist_walker),
                routeName: 'ExerciseTracker',
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
          PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
            context,
            settings: RouteSettings(name: '/$routeName'),
            screen: page,
            withNavBar: true,
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
