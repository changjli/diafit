import 'package:diafit/controller/custom_function.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';

class NutritionReport extends StatefulWidget {
  const NutritionReport({super.key});

  @override
  State<NutritionReport> createState() => _NutritionReportState();
}

class _NutritionReportState extends State<NutritionReport> {
  final _formKey = GlobalKey<FormState>();

  DateTime? date;
  DateTime? startDate;
  DateTime? endDate;

  String id = "";
  String apiToken = "";

  List<Nutrition> nutritions = [];

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

  Future<void> getNutritionReport() async {
    await getAuth();
    try {
      http.Response response = await http.get(
          Uri.parse(
              "http://10.0.2.2:8000/api/nutrition/interval?start_date=$startDate&end_date=$endDate"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          List data = output['data'];
          setState(() {
            nutritions = data.map((d) => Nutrition.fromJson(d)).toList();
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
              const SizedBox(
                height: 10,
              ),
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
              NutritionChart(nutritions: nutritions),
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
                    getNutritionReport();
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

class NutritionChart extends StatefulWidget {
  List<Nutrition> nutritions;
  NutritionChart({super.key, required this.nutritions});

  @override
  State<NutritionChart> createState() => _NutritionChartState();
}

class _NutritionChartState extends State<NutritionChart> {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.days,
        interval: 1,
        rangePadding: ChartRangePadding.additional,
      ),
      series: <LineSeries<Nutrition, DateTime>>[
        LineSeries<Nutrition, DateTime>(
          dataSource: widget.nutritions,
          xValueMapper: (Nutrition data, _) => data.date,
          yValueMapper: (Nutrition data, _) => data.calories_consumed,
        )
      ],
      zoomPanBehavior: ZoomPanBehavior(enablePinching: true),
    );
  }
}

class Nutrition {
  final DateTime date;
  final double calories_consumed;
  Nutrition({required this.date, required this.calories_consumed});

  Nutrition.fromJson(Map json)
      : date = DateTime.parse(json["date"]),
        calories_consumed = json["calories_consumed"].runtimeType == double
            ? json["calories_consumed"]
            : json["calories_consumed"].toDouble();
}
