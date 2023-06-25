import 'package:diafit/controller/custom_function.dart';
import 'package:diafit/pages/Order/show_food.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class ShowMenu extends StatefulWidget {
  final String date;

  const ShowMenu({super.key, required this.date});

  @override
  State<ShowMenu> createState() => _ShowMenuState();
}

class _ShowMenuState extends State<ShowMenu> {
  String apiToken = "";
  List foods = [];

  Future<void> getAuth() async {
    Map temp = await CustomFunction.getAuth();
    apiToken = temp['apiToken'];
  }

  Future<void> getFoods() async {
    await getAuth();
    try {
      String date = widget.date;
      http.Response response = await http.get(
          Uri.parse("http://10.0.2.2:8000/api/food/menu?date=$date"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          List data = output['data'];
          foods = data;
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
          FutureBuilder(
            future: getFoods(),
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
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      return Column(children: [
                        FoodCard(food: foods[index]),
                      ]);
                    },
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final Map food;
  const FoodCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      elevation: 3,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
          onTap: () {
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: ShowFood(foodId: food["id"]),
            );
          },
          child: SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width - 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: NetworkImage(food["image"]),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${food['name']}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Rp. ${food['price']}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 2,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
