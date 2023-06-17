import 'package:diafit/components/custom_button.dart';
import 'package:diafit/components/custom_textfield.dart';
import 'package:diafit/controller/validator.dart';
import 'package:diafit/pages/Tracker/Exercise/result_exercise.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

// Define a custom Form widget.
class CreateExerciseForm extends StatefulWidget {
  const CreateExerciseForm({super.key});

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
        Map data = output[0];
        PersistentNavBarNavigator.pushNewScreen(context,
            screen: ResultExercise(result: data));
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          children: <Widget>[
            CustomTextfield(
                content: 'exercise',
                icon: Icons.food_bank,
                controller: exerciseController,
                validator: Validator.foodValidator),
            const SizedBox(
              height: 20.0,
            ),
            CustomTextfield(
              content: 'duration',
              icon: Icons.punch_clock,
              controller: durationController,
              validator: Validator.servingValidator,
            ),
            const SizedBox(
              height: 20.0,
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
