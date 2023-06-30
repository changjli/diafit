import 'package:diafit/components/custom_button.dart';
import 'package:diafit/components/custom_textfield.dart';
import 'package:diafit/controller/validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Define a custom Form widget.
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class LoginFormState extends State<LoginForm> {
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
    doLogin(emailController.text, passwordcontroller.text);
  }

  void doLogin(email, password) async {
    try {
      // request api
      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/login"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Map data = output['data'];

        // create session
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('login', true);
        await prefs.setString('id', data['id']);
        await prefs.setString('api_token', output['token']);

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        final snackBar = SnackBar(
          content: Text("$output"),
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
                content: 'email',
                icon: Icons.email,
                controller: emailController,
                validator: Validator.emailValidator),
            const SizedBox(
              height: 20,
            ),
            CustomTextfield(
              content: 'password',
              icon: Icons.lock,
              controller: passwordcontroller,
              validator: Validator.passwordValidator,
            ),
            const SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Forgot Password?',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFF757DF0),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, '/register');
                      })
              ]),
            ),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              width: 150,
              height: 50,
              child: CustomButton(
                content: 'Login',
                function: validateInput,
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
