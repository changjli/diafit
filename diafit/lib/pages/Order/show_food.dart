import 'package:diafit/controller/custom_function.dart';
import 'package:diafit/pages/Order/Cart/create_cart_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowFood extends StatefulWidget {
  final String foodId;
  const ShowFood({super.key, required this.foodId});

  @override
  State<ShowFood> createState() => _ShowFoodState();
}

class _ShowFoodState extends State<ShowFood> {
  String apiToken = "";
  Map food = {};

  Future<void> getAuth() async {
    Map temp = await CustomFunction.getAuth();
    apiToken = temp['apiToken'];
  }

  Future<void> getFood() async {
    await getAuth();
    try {
      String foodId = widget.foodId;
      http.Response response = await http.get(
          Uri.parse("http://10.0.2.2:8000/api/food/$foodId"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          food = output['data'];
          print(food);
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
        title: const Text('food'),
      ),
      body: FutureBuilder(
        future: getFood(),
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
              return Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(food['name']),
                          Text(food['serving_size'].toString()),
                        ],
                      ),
                      Text(food['price'].toString()),
                    ],
                  ),
                  const Divider(
                    height: 10,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                    color: Colors.grey,
                  ),
                  const Text("Lorem ipsum"),
                  const Divider(
                    height: 10,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                    color: Colors.grey,
                  ),
                  const Text("Nutritional value per 100g"),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(food['calories'].toString()),
                          const Text("calories"),
                        ],
                      ),
                      Column(
                        children: [
                          Text(food['proteins'].toString()),
                          const Text("proteins"),
                        ],
                      ),
                      Column(
                        children: [
                          Text(food['fats'].toString()),
                          const Text("fat"),
                        ],
                      ),
                      Column(
                        children: [
                          Text(food['carbs'].toString()),
                          const Text("carbs"),
                        ],
                      )
                    ],
                  ),
                  CreateCartForm(food: food),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
