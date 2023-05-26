import 'dart:convert';
import 'package:diafit/controller/custom_function.dart';
import 'package:diafit/pages/Tracker/create_nutrition.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class NutritionTracker extends StatefulWidget {
  const NutritionTracker({super.key});

  @override
  State<NutritionTracker> createState() => _NutritionTrackerState();
}

// refactor
class _NutritionTrackerState extends State<NutritionTracker> {
  String apiToken = "";

  void getToken() async {
    Map temp = await CustomFunction.getAuth();
    apiToken = temp['apiToken'];
  }

  void getReport(DateTime date) async {
    try {
      http.Response response = await http.get(
          Uri.parse("http://10.0.2.2:8000/api/nutrition/report?date=$date"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print(output);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
    // error
    getReport(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nutrition Tracker'),
        ),
        body: Column(children: [
          CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
            onDateChanged: (DateTime value) {
              // print(apiToken);
              getReport(value);
            },
          ),
          IconButton(
              onPressed: () {
                PersistentNavBarNavigator.pushNewScreen(context,
                    screen: const CreateNutrition());
              },
              icon: const Icon(Icons.add))
        ])
        // ElevatedButton(
        //   onPressed: getData,
        //   child: const Text('Proccess'),
        // ),
        );
  }
}
