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
          "calories_per_hour": 0,
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Summary',
                    style: TextStyle(
                      fontSize: 30,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  const Divider(
                    height: 10,
                    indent: 0,
                    endIndent: 0,
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Exercise   :   ${widget.result['name']}",
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Duration    :   ${widget.result['duration_minutes'].toString()} minutes",
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Center(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: caloriesController,
                      decoration: const InputDecoration(
                        label: Text("Calories"),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Store',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        onPressed: () {
                          storeExercise();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
