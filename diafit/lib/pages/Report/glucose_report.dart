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
      // date only
      String temp = date.toString().substring(0, 10);
      date = DateTime.parse(temp);

      http.Response response = await http.get(
          Uri.parse("http://10.0.2.2:8000/api/glucose/report?date=$date"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          List data = output['data'];
          setState(() {
            glucoses = data.map((d) => Glucose.fromJson(d)).toList();
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
        title: const Text('Glucose Report'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller:
                            dateController, //editing controller of this TextField
                        decoration: const InputDecoration(
                            icon:
                                Icon(Icons.calendar_today), //icon of text field
                            labelText: "Date" //label text of field
                            ),
                        readOnly: true, // when true user cannot edit text
                        onTap: () async {
                          date = await datePicker();
                          setState(() {
                            dateController.text = date.toString();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GlucoseChart(glucoses: glucoses),
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
                    getGlucoseReport();
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
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.hours,
        interval: 2,
        rangePadding: ChartRangePadding.additional,
      ),
      series: <LineSeries<Glucose, DateTime>>[
        LineSeries<Glucose, DateTime>(
          dataSource: widget.glucoses,
          xValueMapper: (Glucose data, _) => data.date,
          yValueMapper: (Glucose data, _) => data.sugar_level,
        )
      ],
      zoomPanBehavior: ZoomPanBehavior(enablePinching: true),
    );
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
