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
    if (widget.result['calories'] == null) {
      caloriesController.text = '';
    } else {
      caloriesController.text = widget.result['calories'].toString();
    }
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
          "calories": double.parse(caloriesController.text),
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
                        "Food     :   ${widget.result['name']}",
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
                        "Serving  :   ${widget.result['serving_size_g'].toString()}g",
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
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
                          storeNutrition();
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
