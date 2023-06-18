import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ResultNutrition extends StatefulWidget {
  final Map result;
  DateTime? date;
  ResultNutrition({super.key, required this.result, required this.date});

  @override
  State<ResultNutrition> createState() => _ResultNutritionState();
}

class _ResultNutritionState extends State<ResultNutrition> {
  String apiToken = "";

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiToken = prefs.getString('api_token')!.split('|')[1];
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void storeNutrition() async {
    try {
      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/nutrition"),
        headers: {
          "Authorization": "Bearer $apiToken",
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({
          "name": widget.result['name'],
          "calories": widget.result['calories'].toString(),
          "serving_size_g": widget.result['serving_size_g'].toString(),
          "date": widget.date.toString(),
        }),
      );

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print(output);
        Navigator.popUntil(context, ModalRoute.withName('/NutritionTracker'));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Result'),
      ),
      body: Column(children: [
        Text(widget.result['calories'].toString()),
        ElevatedButton(
          onPressed: storeNutrition,
          child: const Text('add to record'),
        )
      ]),
    );
  }
}
