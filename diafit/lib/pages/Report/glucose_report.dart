import 'package:diafit/components/custom_button.dart';
import 'package:diafit/controller/custom_function.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';

class GlucoseReport extends StatefulWidget {
  const GlucoseReport({super.key});

  @override
  State<GlucoseReport> createState() => _GlucoseReportState();
}

class _GlucoseReportState extends State<GlucoseReport> {
  final _formKey = GlobalKey<FormState>();

  DateTime? date;
  DateTime? startDate;
  DateTime? endDate;

  String id = "";
  String apiToken = "";

  List<Glucose> glucoses = [];

  var dateController = TextEditingController();

  @override
  void dispose() {
    dateController.dispose();
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

  Future<void> getGlucoseReport() async {
    await getAuth();
    try {
      http.Response response = await http.get(
          Uri.parse(
              "http://10.0.2.2:8000/api/glucose/report/summary?date=$date"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          List data = output['data'];
          print(data);
          setState(() {
            glucoses = data.map((d) => Glucose.fromJson(d)).toList();
            print(glucoses[0]);
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
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Center(
                child: Column(children: <Widget>[
                  TextField(
                    controller:
                        dateController, //editing controller of this TextField
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today), //icon of text field
                        labelText: "Start Date" //label text of field
                        ),
                    readOnly: true, // when true user cannot edit text
                    onTap: () async {
                      date = await datePicker();
                      setState(() {
                        dateController.text = date.toString();
                      });
                    },
                  ),
                  CustomButton(content: 'generate', function: getGlucoseReport),
                  GlucoseChart(glucoses: glucoses),
                ]),
              ),
            ),
          ],
        ),
      ),

      // bottomNavigationBar: CustomBottomNavigationBar(route: route),
    );
  }
}

class GlucoseChart extends StatefulWidget {
  List<Glucose> glucoses;
  GlucoseChart({super.key, required this.glucoses});

  @override
  State<GlucoseChart> createState() => _GlucoseChartState();
}

class _GlucoseChartState extends State<GlucoseChart> {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: DateTimeAxis(),
        series: <LineSeries<Glucose, DateTime>>[
          LineSeries<Glucose, DateTime>(
            dataSource: widget.glucoses,
            xValueMapper: (Glucose data, _) => data.date,
            yValueMapper: (Glucose data, _) => data.sugar_level,
          )
        ]);
  }
}

class Glucose {
  final DateTime date;
  final double sugar_level;
  Glucose({required this.date, required this.sugar_level});

  Glucose.fromJson(Map json)
      : date = DateTime.parse(json["date"]),
        sugar_level = double.parse(json["sugar_level"]);
}
