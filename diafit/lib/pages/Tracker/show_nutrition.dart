import 'package:diafit/controller/custom_function.dart';
import 'package:diafit/model/nutrition.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ShowNutrition extends StatefulWidget {
  final Nutrition record;
  const ShowNutrition({super.key, required this.record});

  @override
  State<ShowNutrition> createState() => _ShowNutritionState();
}

class _ShowNutritionState extends State<ShowNutrition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              const SizedBox(height: 30),
              Image.network(
                  "https://source.unsplash.com/350x250?chicken%20food"),
              SfCircularChart(series: <CircularSeries<Nutrition, String>>[
                RadialBarSeries<Nutrition, String>(
                    maximumValue: 6000,
                    radius: '100%',
                    gap: '3%',
                    dataSource: [widget.record],
                    cornerStyle: CornerStyle.bothCurve,
                    xValueMapper: (Nutrition data, _) => data.name,
                    yValueMapper: (Nutrition data, _) => data.calories,
                    pointColorMapper: (Nutrition data, _) => Colors.red)
              ]),
              ElevatedButton(
                onPressed: () async {
                  if (await CustomFunction.deleteNutrition(widget.record.id)) {
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
        ],
      ),
    );
  }
}
