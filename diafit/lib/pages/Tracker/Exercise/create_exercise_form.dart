import 'package:diafit/components/custom_button.dart';
import 'package:diafit/pages/Tracker/Exercise/result_exercise.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

// Define a custom Form widget.
class CreateExerciseForm extends StatefulWidget {
  DateTime? date;
  CreateExerciseForm({super.key, required this.date});

  @override
  CreateExerciseFormState createState() {
    return CreateExerciseFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class CreateExerciseFormState extends State<CreateExerciseForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final exerciseController = TextEditingController();
  final durationController = TextEditingController();
  final timeController = TextEditingController();

  DateTime? dateTime;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    exerciseController.dispose();
    durationController.dispose();
    super.dispose();
  }

  void validateInput() {
    if (_formKey.currentState!.validate()) {
      //If all data are correct then save data to out variables
      _formKey.currentState!.save();
    }
    // storeNutrition(foodController.text, int.parse(servingController.text));
    getData(exerciseController.text, durationController.text);
  }

  void getData(String name, String duration) async {
    try {
      http.Response response = await http.get(
        Uri.parse(
            "https://api.api-ninjas.com/v1/caloriesburned?activity=$name&duration=$duration"),
        headers: {"X-Api-Key": "+vqlyiycXk3ACPLF1J/+3Q==wbWiMSw2bY84EaBf"},
      );

      List output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Map data = {};
        if (output.isEmpty) {
          data = {
            'name': exerciseController.text,
            'duration_minutes': durationController.text
          };
        } else {
          data = output[0];
        }
        PersistentNavBarNavigator.pushNewScreen(context,
            screen: ResultExercise(result: data, date: dateTime));
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<TimeOfDay?> inputTime() async {
    TimeOfDay? time = await showTimePicker(
        context: context, initialTime: const TimeOfDay(hour: 0, minute: 0));
    return time;
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: exerciseController,
                decoration: const InputDecoration(
                  label: Row(
                    children: [
                      Icon(Icons.run_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text('exercise'),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: durationController,
                decoration: const InputDecoration(
                  label: Row(
                    children: [
                      Icon(Icons.punch_clock),
                      SizedBox(
                        width: 10,
                      ),
                      Text('duration in minutes'),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller:
                    timeController, //editing controller of this TextField
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "Time" //label text of field
                    ),
                readOnly: true, // when true user cannot edit text
                onTap: () async {
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
      ),
    );
  }
}
