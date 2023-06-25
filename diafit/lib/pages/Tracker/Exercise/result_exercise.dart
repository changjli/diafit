import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ResultExercise extends StatefulWidget {
  DateTime? date;
  final Map result;
  ResultExercise({super.key, required this.result, required this.date});

  @override
  State<ResultExercise> createState() => _ResultExerciseState();
}

class _ResultExerciseState extends State<ResultExercise> {
  final _formKey = GlobalKey<FormState>();

  String apiToken = "";

  var caloriesController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    caloriesController.dispose();
  }

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiToken = prefs.getString('api_token')!.split('|')[1];
  }

  @override
  void initState() {
    super.initState();
    getToken();
    if (widget.result['total_calories'] == null) {
      caloriesController.text = '';
    } else {
      caloriesController.text = widget.result['total_calories'].toString();
    }
  }

  void storeExercise() async {
    try {
      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/exercise"),
        headers: {
          "Authorization": "Bearer $apiToken",
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({
          "name": widget.result['name'],
          "duration_minutes": widget.result['duration_minutes'].toString(),
          "calories_per_hour": widget.result['calories_per_hour'].toString(),
          "total_calories": double.parse(caloriesController.text),
          "date": widget.date.toString(),
        }),
      );

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print(output);
        Navigator.popUntil(context, ModalRoute.withName('/ExerciseTracker'));
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
      body: Column(
        children: [
          Text(widget.result['name']),
          Text(widget.result['duration_minutes'].toString()),
          Form(
            key: _formKey,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: caloriesController,
                      decoration: const InputDecoration(
                        label: Text("voucher"),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                        onPressed: () => storeExercise(),
                        child: const Text('store')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
