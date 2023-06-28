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
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Image(image: AssetImage('assets/images/diafit.png')),
                const SizedBox(
                  height: 30,
                ),
                // Text(
                //   'Welcome Back',
                //   style: TextStyle(
                //     fontSize: 40,
                //     color: Theme.of(context).colorScheme.primary,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // const SizedBox(
                //   height: 10.0,
                // ),
                // Text(
                //   'Log in to your account',
                //   style: TextStyle(
                //     fontSize: 20,
                //     color: Theme.of(context).colorScheme.primary,
                //   ),
                // ),
                const LoginForm(),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Don't have an account?",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                      TextSpan(
                        text: ' Sign Up',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF757DF0),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/register');
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Image.asset('assets/images/Vector.png'),
            // )
          ],
        ),
      ),
    );
  }
}
