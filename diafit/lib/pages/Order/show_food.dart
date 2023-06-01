import 'package:diafit/controller/custom_function.dart';
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
        title: const Text('haiya'),
      ),
      body: Text(food['name']),
    );
  }
}
