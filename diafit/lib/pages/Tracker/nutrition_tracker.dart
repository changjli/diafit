import 'dart:convert';
import 'package:diafit/controller/custom_function.dart';
import 'package:diafit/pages/Tracker/create_nutrition.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:intl/intl.dart';

class NutritionTracker extends StatefulWidget {
  const NutritionTracker({super.key});

  @override
  State<NutritionTracker> createState() => _NutritionTrackerState();
}

// refactor
class _NutritionTrackerState extends State<NutritionTracker> {
  String apiToken = "";
  bool isLoading = true;
  List records = [];
  DateTime? date;

  Future<void> getToken() async {
    Map auth = await CustomFunction.getAuth();
    apiToken = auth['apiToken'];
  }

  Future<void> getReport(DateTime date) async {
    await getToken();
    try {
      http.Response response = await http.get(
          Uri.parse("http://10.0.2.2:8000/api/nutrition/report?date=$date"),
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
    date = DateTime.now();
    getReport(DateUtils.dateOnly(DateTime.now()));
    // harus date doang
  }

  Future<void> deleteNutrition(String id) async {
    await getToken();
    try {
      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/nutrition/$id"),
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
  Widget build(BuildContext context) {
    // kalo masih request loading
    // kalo udah tunjukkin datanya
    // kalo listnya kosong show error
    // kalo listnya ada isi tunjukkin data
    Widget nutritionRecordsList = isLoading == true
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
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${records[index]['name']}",
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "${records[index]['serving_size_g']}g",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 60,
                            alignment: Alignment.center,
                            child: Text(
                              "+${records[index]['calories']}",
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.red),
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
                              await deleteNutrition(records[index]['id']);
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
                  // return CustomCard(
                  //   record: records[index],
                  // );
                },
              );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Tracker'),
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
                  date = value;
                });
                await getReport(value);
              },
            ),
            // records
            nutritionRecordsList,
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // add
            ElevatedButton(
              onPressed: () async {
                PersistentNavBarNavigator.pushNewScreen(context,
                    screen: CreateNutrition(
                      date: date,
                    )).then((value) async {
                  await getReport(DateUtils.dateOnly(DateTime.now()));
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
