import 'package:diafit/pages/Tracker/Exercise/create_exercise_form.dart';
import 'package:flutter/material.dart';

class CreateExercise extends StatefulWidget {
  DateTime? date;
  CreateExercise({super.key, required this.date});

  @override
  State<CreateExercise> createState() => _CreateExerciseState();
}

class _CreateExerciseState extends State<CreateExercise> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Exercise'),
      ),
      body: CreateExerciseForm(date: widget.date),
    );
  }
}
