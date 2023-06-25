import 'package:diafit/components/custom_button.dart';
import 'package:diafit/controller/custom_function.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dropdown_textfield/dropdown_textfield.dart';

// Define a custom Form widget.
class PaymentForm extends StatefulWidget {
  final Map transaction;
  const PaymentForm({super.key, required this.transaction});

  @override
  PaymentFormState createState() {
    return PaymentFormState();
  }
}

class PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  String apiToken = "";

  final paymentController = SingleValueDropDownController();
  final voucherController = TextEditingController();
  final deliveryController = SingleValueDropDownController();

  String? location = "";

  @override
  void dispose() {
    paymentController.dispose();
    voucherController.dispose();
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
    updateTransaction();
  }

  Future<void> updateTransaction() async {
    await getAuth();
    try {
      http.Response response = await http.post(
        Uri.parse(
            "http://10.0.2.2:8000/api/transaction/${widget.transaction['id']}"),
        headers: {
          "Authorization": "Bearer $apiToken",
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({
          "_method": 'put',
          'payment': paymentController.dropDownValue!.value,
          'voucher_code': voucherController.text,
          'location': location,
          'delivery': deliveryController.dropDownValue!.value,
        }),
      );

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Map data = output['data'];
        print(data);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> rollBack() async {
    await getAuth();
    try {
      http.Response response = await http.post(
        Uri.parse(
            "http://10.0.2.2:8000/api/transaction/${widget.transaction['id']}"),
        headers: {
          "Authorization": "Bearer $apiToken",
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({
          "_method": 'delete',
        }),
      );

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Payment'),
              ),
              DropDownTextField(
                // initialValue: "name4",
                controller: paymentController,
                clearOption: true,
                // enableSearch: true,
                // dropdownColor: Colors.green,
                searchDecoration: const InputDecoration(hintText: "payment"),
                validator: (value) {
                  if (value == null) {
                    return "Required field";
                  } else {
                    return null;
                  }
                },
                dropDownItemCount: 4,

                dropDownList: const [
                  DropDownValueModel(name: 'cash', value: "cash"),
                  DropDownValueModel(name: 'ovo', value: "ovo"),
                  DropDownValueModel(name: 'gopay', value: "gopay"),
                  DropDownValueModel(name: 'dana', value: "dana"),
                ],
                onChanged: (val) {},
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: voucherController,
                decoration: const InputDecoration(
                  label: Text("voucher"),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Choose a branch'),
              ),
              Column(
                children: [
                  RadioListTile(
                    title: const Text("Sudirman"),
                    value: "Sudirman",
                    groupValue: location,
                    onChanged: (value) {
                      setState(() {
                        location = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text("Thamrin"),
                    value: "Thamrin",
                    groupValue: location,
                    onChanged: (value) {
                      setState(() {
                        location = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text("Fatmawati"),
                    value: "Fatmawati",
                    groupValue: location,
                    onChanged: (value) {
                      setState(() {
                        location = value.toString();
                      });
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Delivery'),
              ),
              DropDownTextField(
                // initialValue: "name4",
                controller: deliveryController,
                clearOption: true,
                // enableSearch: true,
                // dropdownColor: Colors.green,
                searchDecoration: const InputDecoration(
                    hintText: "enter your custom hint text here"),
                validator: (value) {
                  if (value == null) {
                    return "Required field";
                  } else {
                    return null;
                  }
                },
                dropDownItemCount: 2,

                dropDownList: const [
                  DropDownValueModel(name: 'gosend', value: "gosend"),
                  DropDownValueModel(name: 'pickup', value: "pickup"),
                ],
                onChanged: (val) {},
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 100,
                    child: CustomButton(
                      content: 'add',
                      function: validateInput,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 50,
                    width: 100,
                    child: CustomButton(
                      content: 'cancel',
                      function: rollBack,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
