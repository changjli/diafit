import 'package:diafit/controller/custom_function.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
          Uri.parse("http://10.0.2.2:8000/api/transaction"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          List data = output['data'];
          transactions = data;
          print(transactions);
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
      body: Column(
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
                      return Text(
                          transactions[index]['total_price'].toString());
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

// class MenuCard extends StatelessWidget {
//   final Map menu;
//   const MenuCard({super.key, required this.menu});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white,
//       elevation: 5,
//       clipBehavior: Clip.hardEdge,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: InkWell(
//           onTap: () {
//             PersistentNavBarNavigator.pushNewScreen(
//               context,
//               screen: ShowMenu(date: menu['date'].toString()),
//             );
//           },
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: Column(
//                   children: [
//                     Text(DateFormat('EEEE')
//                         .format(DateTime.parse(menu['date']))),
//                     Text(menu['date']),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Text(menu['food_count'].toString()),
//               ),
//               const SizedBox(
//                 width: 10,
//               )
//             ],
//           )),
//     );
//   }
// }
