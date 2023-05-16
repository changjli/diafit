import 'package:diafit/pages/login.dart';
import 'package:diafit/pages/register.dart';
import 'package:diafit/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // auth
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? login = prefs.getBool('login');

  runApp(
    MaterialApp(
      initialRoute: '/login',
      // theme: {},
      routes: {
        '/login': (context) {
          // auto login
          if (login != null || login == true) {
            return const Home();
          }
          return const Login();
        },
        '/register': (context) => const Register(),
        '/home': (context) => const Home(),
        // {
        //   if (login == null || login == false) {
        //     return const Login();
        //   }
        //   return const Home();
        // },
      },
    ),
  );
}
