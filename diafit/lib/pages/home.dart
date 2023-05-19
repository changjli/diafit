import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   bool? login = prefs.getBool('login');
//   runApp(MaterialApp(home: login == null ? const Login() : const Home()));
// }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map auth = {};

  void authorize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    auth['login'] = prefs.getBool('login');
    auth['api_token'] = prefs.getString('api_token');
    print(prefs.getBool('login'));
  }

  // String? currentRoute() {
  //   var route = ModalRoute.of(context);

  //   if (route != null) {
  //     return route.settings.name;
  //   }
  //   return null;
  // }

  @override
  void initState() {
    super.initState();
    authorize();
  }

  @override
  Widget build(BuildContext context) {
    // String? route = currentRoute();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      // bottomNavigationBar: CustomBottomNavigationBar(route: route),
    );
    // return CustomBottomNavigationBar();
    // return const Scaffold(
    //   bottomNavigationBar: CustomBottomNavigationBar(),

    // BottomNavigationBar(
    //   type: BottomNavigationBarType.fixed,
    //   items: const [
    //     BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.person,
    //       ),
    //       label: 'Profile',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.receipt,
    //       ),
    //       label: 'Order',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.home,
    //       ),
    //       label: 'Home',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.health_and_safety,
    //       ),
    //       label: 'Tracker',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.book,
    //       ),
    //       label: 'Library',
    //     ),
    //   ],
    //   currentIndex: selectedIndex,
    //   onTap: _onItemTapped,
    // ),
    // );

    // ElevatedButton(
    //   onPressed: () => CustomFunction.logout(
    //       Navigator.pushReplacementNamed(context, '/login')),
    //   // () async {
    //   //   SharedPreferences pref = await SharedPreferences.getInstance();

    //   //   pref.remove("login");
    //   //   pref.remove("api_token");

    //   //   Navigator.pushReplacementNamed(context, '/login');
    //   // },
    //   child: const Text('logout'),
    // );
  }
}
