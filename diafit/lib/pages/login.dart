import 'package:diafit/components/login_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// kalo udah login diarahin ke home, kalo belom diarahin ke login
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   bool? login = prefs.getBool('login');
// }

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3641B7),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 50.0,
            ),
            const Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              'Log in to your account',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
            const LoginForm(),
            RichText(
              text: TextSpan(children: [
                const TextSpan(
                    text: "Don't have an account?",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                    )),
                TextSpan(
                    text: ' Sign Up',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Color(0xFF757DF0),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, '/register');
                      })
              ]),
            )
          ],
        ),
      ),
    );
  }
}
