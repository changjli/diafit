import 'package:diafit/model/nutrition.dart';
import 'package:diafit/pages/Tracker/show_nutrition.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class CustomCard extends StatelessWidget {
  final Nutrition record;
  const CustomCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: InkWell(
          onTap: () {
            PersistentNavBarNavigator.pushNewScreen(context,
                screen: ShowNutrition(
                  record: record,
                ));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '13:00',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.name,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      record.serving_size_g.toString(),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '+${record.calories.toString()}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          )),
    );
  }
}
