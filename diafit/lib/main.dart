import 'package:diafit/Account/edit_profile.dart';
import 'package:diafit/Landing/login.dart';
import 'package:diafit/Tracker/glucose_tracker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diafit/Account/profile.dart';
import 'package:diafit/Landing/landing.dart';
// import 'package:diafit/Tracker/tracker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
