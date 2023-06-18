import 'dart:convert';
import 'package:diafit/controller/custom_function.dart';
import 'package:diafit/pages/Tracker/Exercise/show_exercise.dart';
import 'package:diafit/pages/Tracker/Glucose/create_glucose.dart';
import 'package:diafit/pages/Tracker/Glucose/create_schedule.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class GlucoseTracker extends StatefulWidget {
  const GlucoseTracker({super.key});

  @override
  State<GlucoseTracker> createState() => _GlucoseTrackerState();
}

// refactor
class _GlucoseTrackerState extends State<GlucoseTracker> {
  String apiToken = "";
  bool isLoading = true;
  List records = [];

  Future<void> getToken() async {
    Map auth = await CustomFunction.getAuth();
    apiToken = auth['apiToken'];
  }

  Future<void> getReport(DateTime date) async {
    await getToken();
    try {
      http.Response response = await http.get(
          Uri.parse("http://10.0.2.2:8000/api/glucose/report?date=$date"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          List data = output['data'];
          setState(() {
            isLoading = false;
            records = data;
          });
        } else {
          setState(() {
            isLoading = false;
            records = [];
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    // error
    getReport(DateUtils.dateOnly(DateTime.now()));
    // harus date doang
  }

  @override
  Widget build(BuildContext context) {
    Widget glucoseRecordList = isLoading == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : records.isEmpty
            ? const Text('There is no data')
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: records.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    elevation: 5,
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: InkWell(
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(context,
                              screen: ShowExercise(record: records[index]));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: Theme.of(context).colorScheme.primary,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 70,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '13:00',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    records[index]["sugar_level"],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  );
                },
              );

    return Scaffold(
        appBar: AppBar(
          title: const Text('Glucose Tracker'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // calendar
              CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                onDateChanged: (DateTime value) async {
                  setState(() {
                    isLoading = true;
                  });
                  await getReport(value);
                },
              ),
              // records
              glucoseRecordList,
              // add
              IconButton(
                  onPressed: () {
                    PersistentNavBarNavigator.pushNewScreen(context,
                            screen: const CreateGlucose())
                        .then((value) {
                      getReport(DateUtils.dateOnly(DateTime.now()));
                    });
                  },
                  icon: const Icon(Icons.add)),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: const CreateSchedule());
                  },
                  child: const Text('create schedule')),
            ],
          ),
        )
        // ElevatedButton(
        //   onPressed: getData,
        //   child: const Text('Proccess'),
        // ),
        );
  }
}
