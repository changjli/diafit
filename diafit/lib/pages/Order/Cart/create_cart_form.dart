import 'package:diafit/controller/custom_function.dart';
import 'package:diafit/pages/Order/Cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:input_quantity/input_quantity.dart';

// Define a custom Form widget.
class CreateCartForm extends StatefulWidget {
  final Map food;
  const CreateCartForm({super.key, required this.food});

  @override
  CreateCartFormState createState() {
    return CreateCartFormState();
  }
}

class CreateCartFormState extends State<CreateCartForm> {
  final _formKey = GlobalKey<FormState>();
  String apiToken = "";

  num? quantityController;
  final ValueNotifier<int> subPrice = ValueNotifier<int>(0);

  @override
  void dispose() {
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
    storeCart();
  }

  Future<void> storeCart() async {
    await getAuth();
    try {
      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/cart"),
        headers: {
          "Authorization": "Bearer $apiToken",
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({
          "food_id": widget.food['id'],
          "food_quantity": quantityController,
        }),
      );

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const Cart(),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 1,
            child: Form(
              key: _formKey,
              child: InputQty(
                maxVal: 100,
                initVal: 0,
                minVal: -100,
                isIntrinsicWidth: false,
                borderShape: BorderShapeBtn.circle,
                boxDecoration: const BoxDecoration(),
                steps: 1,
                onQtyChanged: (val) {
                  quantityController = val;
                  int qty = val as int;
                  int price = widget.food['price'];
                  subPrice.value = qty * price;
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 60,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                  ),
                  backgroundColor: const MaterialStatePropertyAll(Colors.black),
                ),
                onPressed: validateInput,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Add to cart",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: subPrice,
                      builder:
                          (BuildContext context, int value, Widget? child) {
                        // This builder will only get called when the _counter
                        // is updated.
                        return Text(
                          "${subPrice.value}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          )
        ],
      ),
    );
    // return Form(
    //   key: _formKey,
    //   child: Center(
    //     child: Row(
    //       children: <Widget>[
    //         Expanded(
    //           child: InputQty(
    //             maxVal: 100,
    //             initVal: 0,
    //             minVal: -100,
    //             isIntrinsicWidth: false,
    //             borderShape: BorderShapeBtn.circle,
    //             boxDecoration: const BoxDecoration(),
    //             steps: 1,
    //             onQtyChanged: (val) {
    //               quantityController = val;
    //             },
    //           ),
    //         ),
    //         const SizedBox(
    //           height: 20.0,
    //         ),
    //         Expanded(
    //           child: CustomButton(
    //             content: 'add',
    //             function: validateInput,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
