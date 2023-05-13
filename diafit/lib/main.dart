import 'package:diafit/login.dart';
import 'package:diafit/register.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Register(),
      },
    ),
  );
}
