import 'package:diafit/controller/custom_function.dart';
import 'package:diafit/pages/Report/exercise_report.dart';
import 'package:diafit/pages/Report/glucose_report.dart';
import 'package:diafit/pages/Report/nutrition_report.dart';
import 'package:diafit/pages/Tracker/Exercise/exercise_tracker.dart';
import 'package:diafit/pages/Tracker/Glucose/glucose_tracker.dart';
import 'package:diafit/pages/Tracker/nutrition_tracker.dart';
import 'package:diafit/pages/summary.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

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
  String apiToken = "";
  String id = "";
  Map user = {};

  double? nutrition;
  double? exercise;
  double? glucose;
  DateTime? date = DateTime.now();

  double? nutritionGoal;
  double? exerciseGoal;
  double? glucoseGoal;

  Future<void> getAuth() async {
    Map temp = await CustomFunction.getAuth();
    id = temp["id"];
    apiToken = temp['apiToken'];
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

  Future<void> getUser() async {
    await getAuth();
    try {
      http.Response response = await http.get(
          Uri.parse("http://10.0.2.2:8000/api/profile/$id"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        user = output;
        String temp = date.toString().substring(0, 10);
        date = DateTime.parse(temp);

        nutritionGoal = double.parse(user['nutritionGoal']);
        exerciseGoal = double.parse(user['exerciseGoal']);
        glucoseGoal = 200;

        await getNutritionReport();
        await getExerciseReport();
        await getGlucoseReport();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getGlucoseReport() async {
    try {
      http.Response response = await http.get(
          Uri.parse(
              "http://10.0.2.2:8000/api/glucose/report/summary?date=$date"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          List data = output['data'];
          glucose = double.tryParse(data[0]['sugar_level']);
        } else {
          print("there is no data");
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getExerciseReport() async {
    try {
      http.Response response = await http.get(
          Uri.parse(
              "http://10.0.2.2:8000/api/exercise/report/summary?start_date=$date&end_date=$date"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          List data = output['data'];
          exercise = double.tryParse(data[0]['calories_burned']);
        } else {
          print("there is no data");
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getNutritionReport() async {
    await getAuth();
    try {
      http.Response response = await http.get(
          Uri.parse(
              "http://10.0.2.2:8000/api/nutrition/report/summary?start_date=$date&end_date=$date"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          List data = output['data'];
          nutrition = data[0]['calories_consumed'];
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
    print(nutrition);
    double nutritionPercentage =
        nutrition != null ? (nutrition! / nutritionGoal!) : 0.0;
    // double exercisePercentage = exercise['calories_burned'] != null
    //     ? (exercise['calories_burned'] / exerciseGoal)
    //     : 0.0;
    List<Map> trackerItem = [
      {
        "name": "Glucose",
        "screen": const GlucoseTracker(),
        "route": "/GlucoseTracker",
        "bg": "assets/images/colorkit.png",
      },
      {
        "name": "Nutrition",
        "screen": const NutritionTracker(),
        "route": "/NutritionTracker",
        "bg": "assets/images/colorkit (1).png",
      },
      {
        "name": "Exercise",
        "screen": const ExerciseTracker(),
        "route": "/ExerciseTracker",
        "bg": "assets/images/colorkit (2).png",
      },
    ];
    List<Map> reportItem = [
      {
        "name": "Glucose",
        "screen": const GlucoseReport(),
        "bg": "assets/images/colorkit (5).png"
      },
      {
        "name": "Nutrition",
        "screen": const NutritionReport(),
        "bg": "assets/images/colorkit (4).png"
      },
      {
        "name": "Exercise",
        "screen": const ExerciseReport(),
        "bg": "assets/images/colorkit (3).png"
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Summary(),
            // Stack(children: [
            //   Row(
            //     children: [
            //       Expanded(
            //         flex: 1,
            //         child: Stack(
            //           children: [
            //             Container(
            //               height: 176,
            //               color: Colors.red,
            //             ),
            //             const Column(
            //               children: [
            //                 SizedBox(
            //                   height: 176 - 150,
            //                 ),
            //                 SizedBox(
            //                   height: 150,
            //                   //
            //                 ),
            //               ],
            //             ),
            //             const Text("hello world"),
            //           ],
            //         ),
            //       ),
            //       Expanded(
            //         flex: 1,
            //         child: Stack(
            //           children: [
            //             Container(
            //               height: 176,
            //               color: Colors.red,
            //             ),
            //             const Column(
            //               children: [
            //                 SizedBox(
            //                   height: 176 - 176,
            //                 ),
            //                 SizedBox(
            //                   height: 176,
            //                   child: WaveBackground(),
            //                 ),
            //               ],
            //             ),
            //             const Text("hello world"),
            //           ],
            //         ),
            //       )
            //     ],
            //   ),
            //   ClipPath(
            //     clipper: TriangleClipper(),
            //     child: Container(
            //       height: 220,
            //       color: Colors.blueAccent,
            //       child: const Center(child: Text("Triangle")),
            //     ),
            //   ),
            // ]),
            const Divider(
              height: 40,
              indent: 0,
              endIndent: 0,
              thickness: 1,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Tracker",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 250,
                // aspectRatio: 16 / 9,
                viewportFraction: 0.55,
                initialPage: 0,
                enableInfiniteScroll: false,
                reverse: false,
                // autoPlay: true,
                // autoPlayInterval: const Duration(seconds: 3),
                // autoPlayAnimationDuration: const Duration(milliseconds: 800),
                // autoPlayCurve: Curves.fastOutSlowIn,
                // enlargeCenterPage: true,
                // enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
                padEnds: false,
              ),
              items: trackerItem.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return InkWell(
                      onTap: () => PersistentNavBarNavigator
                          .pushNewScreenWithRouteSettings(context,
                              screen: i['screen'],
                              settings: RouteSettings(
                                name: i['route'],
                              )),
                      child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("${i['bg']}"),
                                fit: BoxFit.cover),
                            color: Colors.amber,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "${i['name']}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    );
                  },
                );
              }).toList(),
            ),
            const Divider(
              height: 40,
              indent: 0,
              endIndent: 0,
              thickness: 1,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Reports",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 250,
                // aspectRatio: 16 / 9,
                viewportFraction: 0.55,
                initialPage: 0,
                enableInfiniteScroll: false,
                reverse: false,
                // autoPlay: true,
                // autoPlayInterval: const Duration(seconds: 3),
                // autoPlayAnimationDuration: const Duration(milliseconds: 800),
                // autoPlayCurve: Curves.fastOutSlowIn,
                // enlargeCenterPage: true,
                // enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
                padEnds: false,
              ),
              items: reportItem.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return InkWell(
                      onTap: () => PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: i["screen"]),
                      child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("${i['bg']}"),
                                fit: BoxFit.cover),
                            color: Colors.amber,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "${i['name']}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
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

class WaveBackground extends StatefulWidget {
  const WaveBackground({Key? key}) : super(key: key);

  @override
  State<WaveBackground> createState() => _WaveBackgroundState();
}

class _WaveBackgroundState extends State<WaveBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimation(BuildContext context, Widget? widget) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: CustomPaint(
        painter:
            WavePainter(controller: _controller, waves: 4, waveAmplitude: 6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: _buildAnimation,
    );
  }
}

class WavePainter extends CustomPainter {
  late final Animation<double> position;
  final Animation<double> controller;

  /// Number of waves to paint.
  final int waves;

  /// How high the wave should be.
  final double waveAmplitude;
  int get waveSegments => 2 * waves - 1;

  WavePainter(
      {required this.controller,
      required this.waves,
      required this.waveAmplitude}) {
    position = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.linear))
        .animate(controller);
  }

  void drawWave(Path path, int wave, size) {
    double waveWidth = size.width / waveSegments;
    double waveMinHeight = size.height / 2;

    double x1 = wave * waveWidth + waveWidth / 2;
    // Minimum and maximum height points of the waves.
    double y1 = waveMinHeight + (wave.isOdd ? waveAmplitude : -waveAmplitude);

    double x2 = x1 + waveWidth / 2;
    double y2 = waveMinHeight;

    path.quadraticBezierTo(x1, y1, x2, y2);
    if (wave <= waveSegments) {
      drawWave(path, wave + 1, size);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.lightBlue
      ..style = PaintingStyle.fill;

    // Draw the waves
    Path path = Path()..moveTo(0, size.height / 2);
    drawWave(path, 0, size);

    // Draw lines to the bottom corners of the size/screen with account for one extra wave.
    double waveWidth = (size.width / waveSegments) * 2;
    path
      ..lineTo(size.width + waveWidth, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, size.height / 2)
      ..close();

    // Animate sideways one wave length, so it repeats cleanly.
    Path shiftedPath = path.shift(Offset(-position.value * waveWidth, 0));

    canvas.drawPath(shiftedPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
