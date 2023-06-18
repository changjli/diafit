import 'package:diafit/components/custom_button.dart';
import 'package:diafit/components/custom_textfield.dart';
import 'package:diafit/controller/validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Define a custom Form widget.
class CreateGlucoseForm extends StatefulWidget {
  DateTime? date;
  CreateGlucoseForm({super.key, required this.date});

  @override
  CreateGlucoseFormState createState() {
    return CreateGlucoseFormState();
  }
}

class CreateGlucoseFormState extends State<CreateGlucoseForm> {
  String apiToken = "";
  final _formKey = GlobalKey<FormState>();

  DateTime? dateTime;

  final sugarLevelController = TextEditingController();
  final timeController = TextEditingController();

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiToken = prefs.getString('api_token')!.split('|')[1];
  }

  void storeGlucose() async {
    await getToken();
    try {
      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/glucose"),
        headers: {
          "Authorization": "Bearer $apiToken",
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({
          'sugar_level': double.parse(sugarLevelController.text),
          'date': dateTime.toString(),
        }),
      );

      Map output = jsonDecode(response.body);
      print(output);

      if (response.statusCode == 200) {
        Navigator.popUntil(context, ModalRoute.withName('/GlucoseTracker'));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    sugarLevelController.dispose();
    super.dispose();
  }

  void validateInput() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    print(widget.date);
    storeGlucose();
  }

  Future<TimeOfDay?> inputTime() async {
    TimeOfDay? time = await showTimePicker(
        context: context, initialTime: const TimeOfDay(hour: 0, minute: 0));
    return time;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          children: <Widget>[
            CustomTextfield(
                content: 'sugar level',
                icon: Icons.leaderboard,
                controller: sugarLevelController,
                validator: Validator.foodValidator),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: timeController, //editing controller of this TextField
              decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today), //icon of text field
                  labelText: "Time" //label text of field
                  ),
              readOnly: true, // when true user cannot edit text
              onTap: () async {
                print(widget.date);
                TimeOfDay? time = await inputTime();
                setState(() {
                  timeController.text = time.toString();
                  dateTime = DateTime(widget.date!.year, widget.date!.month,
                      widget.date!.day, time!.hour, time.minute);
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              content: 'calculate',
              function: validateInput,
            ),
          ],
        ),
      ),
    );
  }
}
