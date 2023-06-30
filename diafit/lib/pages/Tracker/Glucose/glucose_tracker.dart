import 'dart:convert';
import 'package:diafit/controller/custom_function.dart';
import 'package:diafit/pages/Tracker/Glucose/create_glucose.dart';
import 'package:diafit/pages/Tracker/Glucose/create_schedule.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:intl/intl.dart';

class GlucoseTracker extends StatefulWidget {
  const GlucoseTracker({super.key});

  @override
  State<GlucoseTracker> createState() => _GlucoseTrackerState();
}

// refactor
class _GlucoseTrackerState extends State<GlucoseTracker> {
  DateTime? date;
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

  Future<void> deleteGlucose(String id) async {
    await getToken();
    try {
      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/glucose/$id"),
        headers: {
          "Authorization": "Bearer $apiToken",
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({
          '_method': 'delete',
        }),
      );

      if (response.statusCode == 200) {}
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
            ? Image.asset('assets/images/image-removebg-preview.png')
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: records.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    elevation: 3,
                    clipBehavior: Clip.hardEdge,
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 75,
                            alignment: Alignment.center,
                            color: Theme.of(context).colorScheme.primary,
                            child: Text(
                              DateFormat.Hm().format(
                                  DateTime.parse(records[index]['date'])),
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Sugar Level",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "${records[index]["sugar_level"]} mg/dl",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          const VerticalDivider(
                            width: 10,
                            indent: 0,
                            endIndent: 0,
                            thickness: 1,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await deleteGlucose(records[index]['id']);
                              setState(() {
                                isLoading = true;
                                getReport(DateUtils.dateOnly(DateTime.now()));
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Glucose Tracker'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    date = value;
                  });
                  await getReport(value);
                },
              ),
              // records
              glucoseRecordList,
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10,
            ),
            // schedule
            ElevatedButton(
              onPressed: () {
                PersistentNavBarNavigator.pushNewScreen(context,
                    screen: const CreateSchedule());
              },
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(15),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context)
                      .colorScheme
                      .secondary // <-- Button color
                  ),
              child: const Icon(Icons.schedule),
            ),
            const Expanded(child: SizedBox()),
            // add
            ElevatedButton(
              onPressed: () {
                PersistentNavBarNavigator.pushNewScreen(context,
                        screen: CreateGlucose(date: date))
                    .then((value) {
                  getReport(DateUtils.dateOnly(DateTime.now()));
                });
              },
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(15),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context)
                      .colorScheme
                      .secondary // <-- Button color
                  ),
              child: const Icon(Icons.add),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
      // ElevatedButton(
      //   onPressed: getData,
      //   child: const Text('Proccess'),
      // ),
    );
  }
}
