import 'package:diafit/components/custom_button.dart';
import 'package:diafit/components/custom_textfield.dart';
import 'package:diafit/controller/validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define a custom Form widget.
class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class RegisterFormState extends State<RegisterForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();
  final passwordcontroller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  void validateInput() {
    if (_formKey.currentState!.validate()) {
      //If all data are correct then save data to out variables
      _formKey.currentState!.save();
    }

    doRegister(emailController.text, passwordcontroller.text);
  }

  Future<void> doRegister(email, password) async {
    final GlobalKey<State> keyLoader = GlobalKey<State>();

    try {
      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/register"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      Map output = jsonDecode(response.body);

      if (response.statusCode == 201) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        final snackBar = SnackBar(
          content: Text("${output['message']}"),
          action: SnackBarAction(
            label: 'close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );

        // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
            const SizedBox(
              height: 30,
            ),
            CustomTextfield(
                content: 'Email',
                icon: Icons.email,
                controller: emailController,
                validator: Validator.emailValidator),
            const SizedBox(
              height: 20.0,
            ),
            CustomTextfield(
                content: 'password',
                icon: Icons.lock,
                controller: passwordcontroller,
                validator: Validator.passwordValidator),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              width: 150,
              height: 50,
              child: CustomButton(
                content: 'register',
                function: validateInput,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
