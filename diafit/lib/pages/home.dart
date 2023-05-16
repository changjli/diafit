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
  }

  @override
  void initState() {
    super.initState();
    authorize();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        SharedPreferences pref = await SharedPreferences.getInstance();

        pref.remove("login");
        pref.remove("api_token");

        print(pref.getBool("login"));

        Navigator.pushReplacementNamed(context, '/login');
      },
      child: const Text('logout'),
    );
  }
}
