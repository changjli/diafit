import 'package:diafit/components/custom_button.dart';
import 'package:diafit/components/custom_textfield.dart';
import 'package:diafit/controller/custom_function.dart';
import 'package:diafit/controller/validator.dart';
import 'package:diafit/model/food.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define a custom Form widget.
class CreateMenuForm extends StatefulWidget {
  const CreateMenuForm({super.key});

  @override
  CreateMenuFormState createState() {
    return CreateMenuFormState();
  }
}

class CreateMenuFormState extends State<CreateMenuForm> {
  final _formKey = GlobalKey<FormState>();
  String apiToken = "";
  late Food food;

  final foodController = TextEditingController();
  final servingController = TextEditingController();
  final priceController = TextEditingController();
  final dateController = TextEditingController();
  final imageController = TextEditingController();

  @override
  void dispose() {
    foodController.dispose();
    servingController.dispose();
    priceController.dispose();
    dateController.dispose();
    imageController.dispose();
    super.dispose();
  }

  Future<void> getAuth() async {
    Map auth = await CustomFunction.getAuth();
    apiToken = auth['apiToken'];
  }

  void validateInput() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    await getData(foodController.text, '${servingController.text}g');
    storeMenu();
  }

  Future<void> getData(String name, String size) async {
    try {
      http.Response response = await http.get(
        Uri.parse(
            "https://api.api-ninjas.com/v1/nutrition?query=$name&serving=$size"),
        headers: {"X-Api-Key": "+vqlyiycXk3ACPLF1J/+3Q==wbWiMSw2bY84EaBf"},
      );

      List otuput = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Map data = otuput[0];

        print(data);

        food = Food.fromJson(data, priceController.text, dateController.text);
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> storeMenu() async {
    await getAuth();
    try {
      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/food"),
        headers: {
          "Authorization": "Bearer $apiToken",
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({
          "name": food.name,
          "serving_size": food.serving_size,
          "calories": food.calories,
          "proteins": food.calories,
          "fats": food.fats,
          "carbs": food.carbs,
          "price": food.price,
          "date": food.date.toString(),
          "image": imageController.text,
        }),
      );

      print(response.statusCode);

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print(output);
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          children: <Widget>[
            CustomTextfield(
                content: 'food',
                icon: Icons.lunch_dining,
                controller: foodController,
                validator: Validator.foodValidator),
            const SizedBox(
              height: 20.0,
            ),
            CustomTextfield(
              content: 'serving',
              icon: Icons.scale,
              controller: servingController,
              validator: Validator.servingValidator,
            ),
            const SizedBox(
              height: 20.0,
            ),
            CustomTextfield(
              content: 'price',
              icon: Icons.money,
              controller: priceController,
              validator: Validator.servingValidator,
            ),
            const SizedBox(
              height: 20.0,
            ),
            CustomTextfield(
              content: 'date',
              icon: Icons.calendar_month,
              controller: dateController,
              validator: Validator.servingValidator,
            ),
            const SizedBox(
              height: 20.0,
            ),
            CustomTextfield(
              content: 'image',
              icon: Icons.link,
              controller: imageController,
              validator: Validator.servingValidator,
            ),
            const SizedBox(
              height: 20.0,
            ),
            CustomButton(
              content: 'add',
              function: validateInput,
            ),
          ],
        ),
      ),
    );
  }
}
