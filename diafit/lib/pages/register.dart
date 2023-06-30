import 'package:flutter/material.dart';
import 'package:diafit/components/register_form.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Image(
              image: AssetImage('assets/images/image 5.png'),
            ),
            // Text(
            //   'Register',
            //   style: TextStyle(
            //     fontSize: 40,
            //     color: Theme.of(context).colorScheme.primary,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'Create your account',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const RegisterForm(),
          ],
        ),
        bottomSheet: Image.asset('assets/images/Vector (1).png'),
      ),
    );
  }
}
