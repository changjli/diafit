import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NutritionTracker extends StatefulWidget {
  const NutritionTracker({super.key});

  @override
  State<NutritionTracker> createState() => _NutritionTrackerState();
}

class _NutritionTrackerState extends State<NutritionTracker> {
  void getData() async {
    try {
      http.Response response = await http.get(
        Uri.parse("https://api.api-ninjas.com/v1/nutrition?query=chicken"),
        headers: {"X-Api-Key": "+vqlyiycXk3ACPLF1J/+3Q==wbWiMSw2bY84EaBf"},
      );

      List otuput = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Map data = otuput[0];
        print(data);
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Tracker'),
      ),
      body: ElevatedButton(
        onPressed: getData,
        child: const Text('Proccess'),
      ),
    );
  }
}
