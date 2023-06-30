import 'package:diafit/controller/custom_function.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:percent_indicator/percent_indicator.dart';

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  String apiToken = "";
  String id = "";
  Map user = {};

  double? nutrition;
  double? exercise;
  double? glucose;
  DateTime? date = DateTime.now();

  double? nutritionGoal;
  double? exerciseGoal;
  double? glucoseGoal;

  double nutritionPercentage = 0.0;
  double exercisePercentage = 0.0;
  double glucosePercentage = 0.0;

  Future<void> getAuth() async {
    Map temp = await CustomFunction.getAuth();
    id = temp["id"];
    apiToken = temp['apiToken'];
  }

  Future<void> getUser() async {
    await getAuth();
    try {
      http.Response response = await http.get(
          Uri.parse("http://10.0.2.2:8000/api/profile/$id"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        user = output;

        // date only
        String temp = date.toString().substring(0, 10);
        date = DateTime.parse(temp);

        // goals
        nutritionGoal = double.tryParse(user['nutritionGoal']);
        exerciseGoal = double.tryParse(user['exerciseGoal']);
        glucoseGoal = double.tryParse(user['glucoseGoal']);

        await getNutritionReport();
        await getExerciseReport();
        await getGlucoseReport();

        nutrition = nutrition ?? 0.0;
        exercise = exercise ?? 0.0;
        glucose = glucose ?? 0.0;

        nutritionPercentage =
            nutrition != null ? (nutrition! / nutritionGoal!) : 0.0;
        if (nutritionPercentage > 1) {
          nutritionPercentage = 1.0;
        }
        exercisePercentage =
            exercise != null ? (exercise! / exerciseGoal!) : 0.0;
        if (exercisePercentage > 1) {
          exercisePercentage = 1;
        }
        glucosePercentage = glucose != null ? (glucose! / glucoseGoal!) : 0.0;
        if (glucosePercentage > 1) {
          glucosePercentage = 1;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getNutritionReport() async {
    try {
      http.Response response = await http.get(
          Uri.parse(
              "http://10.0.2.2:8000/api/nutrition/report/summary?start_date=$date&end_date=$date"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);

      print(output);

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          List data = output['data'];
          nutrition = data[0]['calories_consumed'].toDouble();
        } else {
          print("there is no data");
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getExerciseReport() async {
    try {
      http.Response response = await http.get(
          Uri.parse(
              "http://10.0.2.2:8000/api/exercise/report/summary?start_date=$date&end_date=$date"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);

      print(output);

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          List data = output['data'];
          exercise = double.parse(data[0]['calories_burned']);
        } else {
          print("there is no data");
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getGlucoseReport() async {
    try {
      http.Response response = await http.get(
          Uri.parse(
              "http://10.0.2.2:8000/api/glucose/report/summary?date=$date"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          List data = output['data'];
          glucose = data[0]['sugar_level'].toDouble();
        } else {
          print("there is no data");
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occured'),
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircularPercentIndicator(
                  radius: 50,
                  lineWidth: 13.0,
                  animation: true,
                  percent: nutritionPercentage,
                  center: Text(
                    "${nutrition!.toStringAsFixed(1)} / $nutritionGoal",
                    // "${(nutritionPercentage * 100).toStringAsFixed(3)}%",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                  footer: const Text(
                    "Nutrition",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.red,
                ),
                CircularPercentIndicator(
                  radius: 60,
                  lineWidth: 13.0,
                  animation: true,
                  percent: glucosePercentage,
                  center: Text(
                    "${glucose!.toStringAsFixed(1)} / $glucoseGoal",
                    // "${glucosePercentage * 100}%",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  footer: const Text(
                    "Glucose",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.green,
                ),
                CircularPercentIndicator(
                  radius: 50,
                  lineWidth: 13.0,
                  animation: true,
                  percent: exercisePercentage,
                  center: Text(
                    "${exercise!.toStringAsFixed(1)} / $exerciseGoal",
                    // "${(exercisePercentage * 100).toStringAsFixed(3)}%",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                  footer: const Text(
                    "Exercise",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.blue,
                ),
              ],
            );
          }
        }
      },
    );
  }
}
