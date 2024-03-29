import 'package:diafit/controller/custom_function.dart';
import 'package:diafit/pages/Order/Transaction/detail_transaction.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String apiToken = "";
  List transactions = [];

  Future<void> getAuth() async {
    Map temp = await CustomFunction.getAuth();
    apiToken = temp['apiToken'];
  }

  Future<void> getTransactions() async {
    await getAuth();
    try {
      http.Response response = await http.get(
          Uri.parse("http://10.0.2.2:8000/api/transaction/history"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          List data = output['data'];
          transactions = data;
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
                        return HistoryCard(
                            transaction: transactions[index], function: () {});
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

class HistoryCard extends StatelessWidget {
  final Map transaction;
  final Function function;
  const HistoryCard({
    super.key,
    required this.transaction,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: InkWell(
          onTap: () {
            PersistentNavBarNavigator.pushNewScreen(context,
                screen: TransactionDetail(transactionHeader: transaction));
          },
          child: SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width - 20,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${transaction['id']}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "${transaction['created_at']}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 2,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const VerticalDivider(
                    width: 30,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'done',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
