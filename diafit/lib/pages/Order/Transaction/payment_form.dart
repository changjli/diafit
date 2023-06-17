import 'package:diafit/components/custom_button.dart';
import 'package:diafit/components/custom_textfield.dart';
import 'package:diafit/controller/custom_function.dart';
import 'package:diafit/controller/validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  final paymentController = TextEditingController();
  final voucherController = TextEditingController();

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
          'payment': paymentController.text,
          'voucher_code': voucherController.text,
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
        child: Column(
          children: <Widget>[
            CustomTextfield(
              content: 'payment',
              icon: Icons.numbers,
              controller: paymentController,
              validator: Validator.servingValidator,
            ),
            const SizedBox(
              height: 20.0,
            ),
            CustomTextfield(
              content: 'voucher',
              icon: Icons.numbers,
              controller: voucherController,
              validator: Validator.servingValidator,
            ),
            const SizedBox(
              height: 20.0,
            ),
            CustomButton(
              content: 'add',
              function: validateInput,
            ),
            CustomButton(content: 'cancel', function: rollBack),
          ],
        ),
      ),
    );
  }
}
