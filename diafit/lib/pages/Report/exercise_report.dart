import 'package:diafit/controller/custom_function.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExerciseReport extends StatefulWidget {
  const ExerciseReport({super.key});

  @override
  State<ExerciseReport> createState() => _ExerciseReportState();
}

class _ExerciseReportState extends State<ExerciseReport> {
  final _formKey = GlobalKey<FormState>();

  DateTime? date;
  DateTime? startDate;
  DateTime? endDate;

  String id = "";
  String apiToken = "";

  List<Exercise> exercises = [];

  var startDateController = TextEditingController();
  var endDateController = TextEditingController();

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  Future<void> getAuth() async {
    Map temp = await CustomFunction.getAuth();
    id = temp['id'];
    apiToken = temp['apiToken'];
  }

  void validateInput() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

  @override
  void initState() {
    super.initState();
    // authorize();
  }

  Future<DateTime?> datePicker() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), //get today's date
        firstDate: DateTime(
            2000), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));
    return date;
  }

  Future<void> getExerciseReport() async {
    await getAuth();
    try {
      http.Response response = await http.get(
          Uri.parse(
              "http://10.0.2.2:8000/api/exercise/interval?start_date=$startDate&end_date=$endDate"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);
      print(output);

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          List data = output['data'];
          setState(() {
            exercises = data.map((d) => Exercise.fromJson(d)).toList();
            print(exercises[0]);
          });
        } else {
          print("there is no data");
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Center(
                  child: Column(children: <Widget>[
                    TextField(
                      controller:
                          startDateController, //editing controller of this TextField
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today), //icon of text field
                          labelText: "Start Date" //label text of field
                          ),
                      readOnly: true, // when true user cannot edit text
                      onTap: () async {
                        date = await datePicker();
                        setState(() {
                          startDateController.text = date.toString();
                          startDate = date;
                        });
                      },
                    ),
                    TextField(
                        controller: endDateController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today),
                          labelText: "End Date",
                        ),
                        readOnly: true,
                        onTap: () async {
                          date = await datePicker();
                          setState(() {
                            endDateController.text = date.toString();
                            endDate = date;
                          });
                        }),
                  ]),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ExerciseChart(exercises: exercises),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Calculate',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  onPressed: () {
                    getExerciseReport();
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // bottomNavigationBar: CustomBottomNavigationBar(route: route),
    );
  }
}

class ExerciseChart extends StatefulWidget {
  List<Exercise> exercises;
  ExerciseChart({super.key, required this.exercises});

  @override
  State<ExerciseChart> createState() => _ExerciseChartState();
}

class _ExerciseChartState extends State<ExerciseChart> {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: DateTimeAxis(
          intervalType: DateTimeIntervalType.days,
          interval: 1,
          rangePadding: ChartRangePadding.additional,
        ),
        series: <LineSeries<Exercise, DateTime>>[
          LineSeries<Exercise, DateTime>(
            dataSource: widget.exercises,
            xValueMapper: (Exercise data, _) => data.date,
            yValueMapper: (Exercise data, _) => data.calories_burned,
          )
        ]);
  }
}

class Exercise {
  final DateTime date;
  final double calories_burned;
  Exercise({required this.date, required this.calories_burned});

  Exercise.fromJson(Map json)
      : date = DateTime.parse(json["date"]),
        calories_burned = double.parse(json["calories_burned"]);
}
