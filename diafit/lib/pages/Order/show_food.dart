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
      body: SingleChildScrollView(
        child: FutureBuilder(
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
                return Body(food: food);
                // return Column(
                //   children: [
                //     Image(image: NetworkImage(food["image"])),
                //     Row(
                //       children: [
                //         Column(
                //           children: [
                //             Text(food['name']),
                //             Text(food['serving_size'].toString()),
                //           ],
                //         ),
                //         Text(food['price'].toString()),
                //       ],
                //     ),
                //     const Divider(
                //       height: 10,
                //       thickness: 1,
                //       indent: 0,
                //       endIndent: 0,
                //       color: Colors.grey,
                //     ),
                //     const Text("Lorem ipsum"),
                //     const Divider(
                //       height: 10,
                //       thickness: 1,
                //       indent: 0,
                //       endIndent: 0,
                //       color: Colors.grey,
                //     ),
                //     const Text("Nutritional value per 100g"),
                //     Row(
                //       children: [
                //         Column(
                //           children: [
                //             Text(food['calories'].toString()),
                //             const Text("calories"),
                //           ],
                //         ),
                //         Column(
                //           children: [
                //             Text(food['proteins'].toString()),
                //             const Text("proteins"),
                //           ],
                //         ),
                //         Column(
                //           children: [
                //             Text(food['fats'].toString()),
                //             const Text("fat"),
                //           ],
                //         ),
                //         Column(
                //           children: [
                //             Text(food['carbs'].toString()),
                //             const Text("carbs"),
                //           ],
                //         )
                //       ],
                //     ),
                //     CreateCartForm(food: food),
                //   ],
                // );
              }
            }
          },
        ),
      ),
      bottomNavigationBar: CreateCartForm(
        food: food,
      ),
    );
  }
}

class Body extends StatelessWidget {
  Map food = {};
  Body({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.5,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              image: DecorationImage(
                image: NetworkImage(food["image"]),
                fit: BoxFit.cover,
                opacity: 0.9,
              )),
          child: const Column(
            children: [
              Spacer(),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          food["name"],
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          food["price"].toString(),
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      food["serving_size"].toString(),
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black45,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: .3,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: .3,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Nutritional value per 100gr",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 2,
                    ),
                    child: Column(
                      children: [
                        Text(
                          food["calories"].toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "kkal",
                          style: TextStyle(
                            color: Color.fromARGB(179, 0, 0, 0),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 2,
                    ),
                    child: Column(
                      children: [
                        Text(
                          food["proteins"].toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "proteins",
                          style: TextStyle(
                            color: Color.fromARGB(179, 0, 0, 0),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 2,
                    ),
                    child: Column(
                      children: [
                        Text(
                          food["fats"].toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "fats",
                          style: TextStyle(
                            color: Color.fromARGB(179, 0, 0, 0),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 2,
                    ),
                    child: Column(
                      children: [
                        Text(
                          food["carbs"].toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "carbs",
                          style: TextStyle(
                            color: Color.fromARGB(179, 0, 0, 0),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
