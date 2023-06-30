import 'package:diafit/pages/Tracker/create_nutrition_form.dart';
import 'package:flutter/material.dart';

class CreateNutrition extends StatefulWidget {
  DateTime? date;
  CreateNutrition({super.key, required this.date});

  @override
  State<CreateNutrition> createState() => _CreateNutritionState();
}

class _CreateNutritionState extends State<CreateNutrition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Nutrition'),
      ),
      body: CreateNutritionForm(
        date: widget.date,
      ),
    );
  }
}
