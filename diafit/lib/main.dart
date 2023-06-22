import 'package:diafit/Account/profile.dart';
import 'package:flutter/material.dart';
import 'package:diafit/Order/order.dart';
import 'package:diafit/Order/food_rec.dart';
import 'package:diafit/Order/cart.dart';
// import 'package:diafit/Tracker/tracker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Cart(),
    );
  }
}
