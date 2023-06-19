import 'package:diafit/controller/custom_function.dart';
import 'package:diafit/pages/Order/Cart/cart.dart';
import 'package:diafit/pages/Order/Transaction/history.dart';
import 'package:diafit/pages/Order/create_menu.dart';
import 'package:diafit/pages/Order/show_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:intl/intl.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String apiToken = "";
  List menus = [];

  Future<void> getAuth() async {
    Map temp = await CustomFunction.getAuth();
    apiToken = temp['apiToken'];
  }

  Future<void> getMenu() async {
    await getAuth();
    try {
      http.Response response = await http.get(
          Uri.parse("http://10.0.2.2:8000/api/food"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          List data = output['data'];
          menus = data;
        } else {
          print('there is no data');
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
        title: const Text('Order'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              PersistentNavBarNavigator.pushNewScreen(context,
                      screen: const CreateMenu())
                  .then((value) async {
                await getMenu();
                setState(() {});
              });
            },
            child: const Text('add'),
          ),
          FutureBuilder(
            future: getMenu(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('An error occured'),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: menus.length,
                    itemBuilder: (context, index) {
                      return Column(children: [
                        CustomCard(menu: menus[index]),
                        const SizedBox(
                          height: 20,
                        )
                      ]);
                    },
                  );
                }
              }
            },
          ),
          ElevatedButton(
            onPressed: () async {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: const Cart());
            },
            child: const Text('cart'),
          ),
          ElevatedButton(
            onPressed: () async {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: const History());
            },
            child: const Text('history'),
          ),
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Map menu;
  const CustomCard({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: ShowMenu(date: menu['date'].toString()),
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 20,
        height: 125,
        child: Container(
          width: 380,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 2.0),
                blurRadius: 10,
                spreadRadius: -5,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 28,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          DateFormat('EEEE')
                              .format(DateTime.parse(menu['date']))
                              .substring(0, 3),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            letterSpacing: 2,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                          height: 40,
                          // decoration: const BoxDecoration(
                          //   image: DecorationImage(
                          //     image: AssetImage(
                          //       "images/weather-icon.png",
                          //     ),
                          //     fit: BoxFit.cover,
                          //     opacity: 0.9,
                          //   ),
                          // ),
                        ),
                      ],
                    ),
                    Text(
                      DateFormat('dd MMMM yyyy')
                          .format(DateTime.parse(menu['date'])),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.8,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 150,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  // image: const DecorationImage(
                  //   image: AssetImage(
                  //     "images/junkFood.jpg",
                  //   ),
                  //   fit: BoxFit.cover,
                  //   opacity: 0.9,
                  // ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${menu['food_count']} Times",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 15),
                width: 50,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                          // image: DecorationImage(
                          //   image: AssetImage(
                          //     "images/next-icon.png",
                          //   ),
                          //   fit: BoxFit.cover,
                          //   opacity: 0.9,
                          // ),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Container(
      //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      //   constraints: const BoxConstraints(
      //     minHeight: 100,
      //   ),
      //   child: IntrinsicHeight(
      //     child: Row(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         Expanded(
      //           flex: 1,
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text(
      //                 DateFormat('EEEE')
      //                     .format(DateTime.parse(menu['date']))
      //                     .substring(0, 3),
      //                 style: const TextStyle(
      //                   fontSize: 25,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //               Text(
      //                 DateFormat('dd MMMM yyyy')
      //                     .format(DateTime.parse(menu['date'])),
      //                 style: const TextStyle(
      //                   fontSize: 12,
      //                   fontWeight: FontWeight.normal,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         VerticalDivider(
      //           width: 40,
      //           thickness: 1,
      //           indent: 0,
      //           endIndent: 0,
      //           color: Theme.of(context).colorScheme.primary,
      //         ),
      //         Expanded(
      //           flex: 1,
      //           child: Container(
      //             padding: const EdgeInsets.symmetric(
      //                 horizontal: 10, vertical: 10),
      //             decoration: BoxDecoration(
      //               color: Theme.of(context).colorScheme.primary,
      //               borderRadius: BorderRadius.circular(15),
      //             ),
      //             child: Expanded(
      //               child: Align(
      //                 alignment: Alignment.center,
      //                 child: Row(children: [
      //                   Text(
      //                     '${menu['food_count']} Times',
      //                     style: const TextStyle(
      //                       fontSize: 20,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                   const Icon(
      //                     Icons.restaurant,
      //                   )
      //                 ]),
      //               ),
      //             ),
      //           ),
      //         ),
      //         const SizedBox(
      //           width: 20,
      //         ),
      //         Expanded(
      //           child: Container(
      //             padding: const EdgeInsets.symmetric(horizontal: 5),
      //             decoration: BoxDecoration(
      //               color: Theme.of(context).colorScheme.primary,
      //               borderRadius: BorderRadius.circular(15),
      //             ),
      //             child: const Align(
      //               alignment: Alignment.center,
      //               child: Icon(
      //                 Icons.arrow_forward_ios,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // )
    );
  }
}
