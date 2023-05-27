import 'package:diafit/controller/custom_function.dart';
import 'package:diafit/model/nutrition.dart';
import 'package:flutter/material.dart';

class ShowNutrition extends StatelessWidget {
  final Nutrition record;
  const ShowNutrition({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(record.name),
          ElevatedButton(
            onPressed: () async {
              if (await CustomFunction.deleteNutrition(record.id)) {
                Navigator.popUntil(
                    context, ModalRoute.withName('/NutritionTracker'));
              } else {
                print('error');
              }
            },
            child: const Text('delete'),
          )
        ],
      ),
    );
  }
}
