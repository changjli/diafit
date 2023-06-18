import 'package:diafit/components/custom_button.dart';
import 'package:diafit/components/custom_textfield.dart';
import 'package:diafit/controller/validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Define a custom Form widget.
class CreateGlucoseForm extends StatefulWidget {
  const CreateGlucoseForm({super.key});

  @override
  CreateGlucoseFormState createState() {
    return CreateGlucoseFormState();
  }
}

class CreateGlucoseFormState extends State<CreateGlucoseForm> {
  String apiToken = "";
  final _formKey = GlobalKey<FormState>();

  final sugarLevelController = TextEditingController();

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
    storeGlucose();
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
