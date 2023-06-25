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

  Future<void> getAuth() async {
    Map temp = await CustomFunction.getAuth();
    id = temp["id"];
    apiToken = temp['apiToken'];
  }

  @override
  void initState() {
    super.initState();
    // authorize();
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
        // glucoseGoal = double.tryParse(user['glucoseGoal']);

        await getNutritionReport();
        await getExerciseReport();
        await getGlucoseReport();
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

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          List data = output['data'];
          nutrition = data[0]['calories_consumed'];
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

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          List data = output['data'];
          exercise = double.tryParse(data[0]['calories_burned']);
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
    double nutritionPercentage =
        nutrition != null ? (nutrition! / nutritionGoal!) : 0.0;
    print(nutritionPercentage);
    double exercisePercentage =
        exercise != null ? (exercise! / exerciseGoal!) : 0.0;
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
                    "${nutritionPercentage * 100}%",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0),
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
                  percent: 0.7,
                  center: Text(
                    "${exercisePercentage * 100}%",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0),
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
                    "${exercisePercentage * 100}%",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0),
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
