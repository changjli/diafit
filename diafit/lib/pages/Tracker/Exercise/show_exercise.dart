import 'package:flutter/material.dart';

class ShowExercise extends StatefulWidget {
  final Map record;
  const ShowExercise({super.key, required this.record});

  @override
  State<ShowExercise> createState() => _ShowExerciseState();
}

class _ShowExerciseState extends State<ShowExercise> {
  @override
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
                  "https://source.unsplash.com/350x250?${widget.record['name']}"),
              // SfCircularChart(
              //   series: const <CircularSeries<Nutrition, String>>[
              //     RadialBarSeries<Map, String>(
              //         maximumValue: 300,
              //         radius: '100%',
              //         gap: '3%',
              //         dataSource: [widget.record],
              //         cornerStyle: CornerStyle.bothCurve,
              //         xValueMapper: (Nutrition data, _) => data.name,
              //         yValueMapper: (Nutrition data, _) => data.calories,
              //         pointColorMapper: (Nutrition data, _) => Colors.red,
              //         dataLabelSettings: const DataLabelSettings(
              //           isVisible: true,
              //         )),
              //   ],
              // ),
              ElevatedButton(
                onPressed: () async {},
                child: const Text('delete'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
