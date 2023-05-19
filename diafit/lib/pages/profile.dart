import 'package:flutter/material.dart';
import 'package:diafit/controller/custom_function.dart';
import 'package:diafit/pages/login.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:diafit/pages/order.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // String? currentRoute() {
  //   var route = ModalRoute.of(context);

  //   if (route != null) {
  //     return route.settings.name;
  //   }
  //   return null;
  // }

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
                    MaterialPageRoute(builder: (context) => const Login()))),

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
