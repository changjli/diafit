import 'package:diafit/controller/custom_function.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionDetail extends StatefulWidget {
  final Map transactionHeader;
  const TransactionDetail({super.key, required this.transactionHeader});

  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  String apiToken = "";
  List transactions = [];
  List foods = [];

  Future<void> getAuth() async {
    Map temp = await CustomFunction.getAuth();
    apiToken = temp['apiToken'];
  }

  Future<void> getTransactions() async {
    await getAuth();
    try {
      http.Response response = await http.get(
          Uri.parse(
              "http://10.0.2.2:8000/api/transaction/detail?transaction_id=${widget.transactionHeader['id']}"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);
      print(output);

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          List data = output['data'];
          transactions = data;
          foods = output['foods'];
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
        title: const Text('history'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: getTransactions(),
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
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        return TransactionCard(
                            food: foods[index],
                            transaction: transactions[index]);
                      },
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final Map food;
  final Map transaction;
  const TransactionCard(
      {super.key, required this.food, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      elevation: 3,
      clipBehavior: Clip.hardEdge,
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
                  "${food['name']} x ${transaction['food_quantity']}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Rp. ${transaction['food_quantity'] * food['price']}",
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
      ),
    );
  }
}
