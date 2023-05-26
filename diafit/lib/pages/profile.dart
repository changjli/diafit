import 'package:diafit/pages/bio_data.dart';
import 'package:flutter/material.dart';
import 'package:diafit/controller/custom_function.dart';
import 'package:diafit/pages/login.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String id = "";
  String apiToken = "";

  void getAuth() async {
    Map temp = await CustomFunction.getAuth();
    id = temp['id'];
    apiToken = temp['apiToken'];
  }

  @override
  void initState() {
    super.initState();
    getAuth();
  }

  @override
  Widget build(BuildContext context) {
    // String? route = currentRoute();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: const BioData(),
              );
            },
            child: const Text('Bio Data'),
          ),
          ElevatedButton(
            onPressed: () => CustomFunction.logout(
              // cupertino
              // PersistentNavBarNavigator.pushNewScreen(
              //   context,
              //   screen: const Login(),
              //   withNavBar: true, // OPTIONAL VALUE. True by default.
              //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
              // ),

              // owh ini jadi refer ke root
              // keluar dari CustomNavigationBar
              Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Login())),
              id,
            ),

            // logout before refactor
            // () async {
            //   //   SharedPreferences pref = await SharedPreferences.getInstance();

            //   //   pref.remove("login");
            //   //   pref.remove("api_token");

            //   //   Navigator.pushReplacementNamed(context, '/login');
            //   // },
            child: const Text('Logout'),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     // PersistentNavBarNavigator.pushNewScreen(
          //     //   context,
          //     //   screen: const Order(),
          //     //   withNavBar: true,
          //     // );
          //     Navigator.pushNamed(context, '/order');
          //   },
          //   child: const Text('Order'),
          // )
        ],
      ),
      // bottomNavigationBar: CustomBottomNavigationBar(
      //   route: route,
      // ),
    );
  }
}
