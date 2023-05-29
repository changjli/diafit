import 'dart:convert';
import 'package:diafit/components/custom_card.dart';
import 'package:diafit/controller/custom_function.dart';
import 'package:diafit/model/nutrition.dart';
import 'package:diafit/pages/Tracker/create_nutrition.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class NutritionTracker extends StatefulWidget {
  const NutritionTracker({super.key});

  @override
  State<NutritionTracker> createState() => _NutritionTrackerState();
}

// refactor
class _NutritionTrackerState extends State<NutritionTracker> {
  String apiToken = "";
  bool isLoading = true;
  List<Nutrition> records = [];

  Future<void> getToken() async {
    Map temp = await CustomFunction.getAuth();
    apiToken = temp['apiToken'];
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
          // print(data);
          setState(() {
            isLoading = false;
            records = data.map((d) => Nutrition.fromJson(d)).toList();
          });
        } else {
          print(output['success']);
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
    // kalo masih request loading
    // kalo udah tunjukkin datanya
    // kalo listnya kosong show error
    // kalo listnya ada isi tunjukkin data
    Widget nutritionRecordsList = isLoading == true
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
                  return CustomCard(
                    record: records[index],
                  );
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
                  });
                  await getReport(value);
                },
              ),
              // records
              nutritionRecordsList,
              // add
              IconButton(
                  onPressed: () {
                    PersistentNavBarNavigator.pushNewScreen(context,
                            screen: const CreateNutrition())
                        .then((value) {
                      getReport(DateUtils.dateOnly(DateTime.now()));
                    });
                  },
                  icon: const Icon(Icons.add)),
              const SizedBox(
                height: 10,
              )
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
