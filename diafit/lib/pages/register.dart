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
    return Scaffold(
      backgroundColor: const Color(0xFF3641B7),
      appBar: AppBar(),
      body: Column(
        children: const [
          Text(
            'Register',
          ),
          SizedBox(
            height: 10.0,
          ),
          Text('Create your account'),
          RegisterForm(),
        ],
      ),
    );
  }
}
