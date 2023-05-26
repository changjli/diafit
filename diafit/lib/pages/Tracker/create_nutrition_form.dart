import 'package:diafit/components/custom_button.dart';
import 'package:diafit/components/custom_textfield.dart';
import 'package:diafit/controller/validator.dart';
import 'package:diafit/pages/Tracker/result_nutrition.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

// Define a custom Form widget.
class CreateNutritionForm extends StatefulWidget {
  const CreateNutritionForm({super.key});

  @override
  CreateNutritionFormState createState() {
    return CreateNutritionFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class CreateNutritionFormState extends State<CreateNutritionForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final foodController = TextEditingController();
  final servingController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    foodController.dispose();
    servingController.dispose();
    super.dispose();
  }

  void validateInput() {
    if (_formKey.currentState!.validate()) {
      //If all data are correct then save data to out variables
      _formKey.currentState!.save();
    }
    // storeNutrition(foodController.text, int.parse(servingController.text));
    getData(foodController.text, '${servingController.text}g');
  }

  void getData(String name, String size) async {
    try {
      http.Response response = await http.get(
        Uri.parse(
            "https://api.api-ninjas.com/v1/nutrition?query=$name&serving=$size"),
        headers: {"X-Api-Key": "+vqlyiycXk3ACPLF1J/+3Q==wbWiMSw2bY84EaBf"},
      );

      List otuput = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Map data = otuput[0];
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: ResultNutrition(result: data),
        );
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
                content: 'food',
                icon: Icons.lunch_dining,
                controller: foodController,
                validator: Validator.foodValidator),
            const SizedBox(
              height: 20.0,
            ),
            CustomTextfield(
              content: 'serving',
              icon: Icons.scale,
              controller: servingController,
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
