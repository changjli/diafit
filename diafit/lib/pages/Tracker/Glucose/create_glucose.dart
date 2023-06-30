import 'package:diafit/pages/Tracker/Glucose/create_glucose_form.dart';
import 'package:flutter/material.dart';

class CreateGlucose extends StatefulWidget {
  DateTime? date;
  CreateGlucose({super.key, required this.date});

  @override
  State<CreateGlucose> createState() => _CreateGlucoseState();
}

class _CreateGlucoseState extends State<CreateGlucose> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Glucose'),
      ),
      body: CreateGlucoseForm(date: widget.date),
    );
  }
}
