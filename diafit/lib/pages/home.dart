import 'package:diafit/components/custom_button.dart';
import 'package:diafit/controller/custom_function.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   bool? login = prefs.getBool('login');
//   runApp(MaterialApp(home: login == null ? const Login() : const Home()));
// }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  // void authorize() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   auth['login'] = prefs.getBool('login');
  //   auth['api_token'] = prefs.getString('api_token');
  //   print(prefs.getBool('login'));
  // }

  // String? currentRoute() {
  //   var route = ModalRoute.of(context);

  //   if (route != null) {
  //     return route.settings.name;
  //   }
  //   return null;
  // }

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
              "http://10.0.2.2:8000/api/nutrition/report/summary?start_date=$startDate&end_date=$endDate"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          List data = output['data'];
          setState(() {
            nutritions = data.map((d) => Nutrition.fromJson(d)).toList();
            print(nutritions[0]);
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
    // String? route = currentRoute();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: <Widget>[
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
                CustomButton(content: 'generate', function: getNutritionReport),
                NutritionChart(nutritions: nutritions),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: CustomBottomNavigationBar(route: route),
    );
    // return CustomBottomNavigationBar();
    // return const Scaffold(
    //   bottomNavigationBar: CustomBottomNavigationBar(),

    // BottomNavigationBar(
    //   type: BottomNavigationBarType.fixed,
    //   items: const [
    //     BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.person,
    //       ),
    //       label: 'Profile',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.receipt,
    //       ),
    //       label: 'Order',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.home,
    //       ),
    //       label: 'Home',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.health_and_safety,
    //       ),
    //       label: 'Tracker',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.book,
    //       ),
    //       label: 'Library',
    //     ),
    //   ],
    //   currentIndex: selectedIndex,
    //   onTap: _onItemTapped,
    // ),
    // );

    // ElevatedButton(
    //   onPressed: () => CustomFunction.logout(
    //       Navigator.pushReplacementNamed(context, '/login')),
    //   // () async {
    //   //   SharedPreferences pref = await SharedPreferences.getInstance();

    //   //   pref.remove("login");
    //   //   pref.remove("api_token");

    //   //   Navigator.pushReplacementNamed(context, '/login');
    //   // },
    //   child: const Text('logout'),
    // );
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
        primaryXAxis: DateTimeAxis(),
        series: <LineSeries<Nutrition, DateTime>>[
          LineSeries<Nutrition, DateTime>(
            dataSource: widget.nutritions,
            xValueMapper: (Nutrition data, _) => data.date,
            yValueMapper: (Nutrition data, _) => data.calories_consumed,
          )
        ]);
  }
}

class Nutrition {
  final DateTime date;
  final double calories_consumed;
  Nutrition({required this.date, required this.calories_consumed});

  Nutrition.fromJson(Map json)
      : date = DateTime.parse(json["date"]),
        calories_consumed = json["calories_consumed"];
}
