import 'package:diafit/controller/custom_function.dart';
import 'package:diafit/pages/Order/Transaction/payment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  String apiToken = "";
  List carts = [];

  Future<void> getAuth() async {
    Map temp = await CustomFunction.getAuth();
    apiToken = temp['apiToken'];
  }

  Future<void> getCart() async {
    await getAuth();
    try {
      http.Response response = await http.get(
          Uri.parse("http://10.0.2.2:8000/api/cart"),
          headers: {"Authorization": "Bearer $apiToken"});

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (output['success'] == true) {
          List data = output['data'];
          carts = data;
          print(carts);
        } else {
          print('there is no data');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> storeTransaction() async {
    await getAuth();
    try {
      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/transaction"),
        headers: {
          "Authorization": "Bearer $apiToken",
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({}),
      );

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Map data = output['data'];
        print(data);
        updateCart(data['id']);
      }
    } catch (e) {
      print(e);
    }
  }

  void updateCart(String $id) async {
    await getAuth();
    try {
      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/cart"),
        headers: {
          "Authorization": "Bearer $apiToken",
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({
          "_method": 'put',
          "transaction_id": $id,
        }),
      );

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        List data = output['data'];
        print(data);
        updateTransaction($id);
      }
    } catch (e) {
      print(e);
    }
  }

  void updateTransaction(String $id) async {
    await getAuth();
    try {
      String temp = $id;
      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/transaction/$temp"),
        headers: {
          "Authorization": "Bearer $apiToken",
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({
          "_method": 'put',
        }),
      );

      Map output = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Map data = output['data'];
        PersistentNavBarNavigator.pushNewScreen(context,
            screen: Payment(
              transaction: data,
            ));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('cart'),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: getCart(),
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
                  return Column(children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: carts.length,
                      itemBuilder: (context, index) {
                        return const Text('hello world');
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await storeTransaction();
                      },
                      child: const Text('check out'),
                    ),
                  ]);
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
