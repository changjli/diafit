import 'package:diafit/pages/Tracker/Exercise/create_exercise_form.dart';
import 'package:flutter/material.dart';

class CreateExercise extends StatefulWidget {
  const CreateExercise({super.key});

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
      body: const CreateExerciseForm(),
    );
  }
}
