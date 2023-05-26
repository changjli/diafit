import 'package:diafit/pages/Tracker/create_nutrition_form.dart';
import 'package:flutter/material.dart';

class CreateNutrition extends StatefulWidget {
  const CreateNutrition({super.key});

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
      body: const CreateNutritionForm(),
    );
  }
}
