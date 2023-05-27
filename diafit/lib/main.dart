import 'package:diafit/components/custom_bottom_navigation_bar.dart';
import 'package:diafit/pages/login.dart';
import 'package:diafit/pages/register.dart';
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
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF3641B7),
          onPrimary: Colors.white,
          secondary: Color(0xFFD9DBFF),
          onSecondary: Color(0xFF3641B7),
          error: Color(0xFF931A1A),
          onError: Colors.white,
          background: Colors.white,
          onBackground: Color(0xFF3641B7),
          surface: Colors.white,
          onSurface: Color(0xFF3641B7),
        ),
      ),
      routes: {
        '/login': (context) {
          // auto login
          if (login != null && login == true) {
            return const CustomBottomNavigationBar();
          }
          return const Login();
        },
        '/register': (context) => const Register(),
        '/home': (context) => const CustomBottomNavigationBar(),
      },

      // routes: {
      //   '/login': (context) {
      //     // auto login
      //     if (login != null || login == true) {
      //       return const Home();
      //     }
      //     return const Login();
      //   },
      //   '/register': (context) => const Register(),
      //   '/home': (context) => const Home(),
      //   // {
      //   //   if (login == null || login == false) {
      //   //     return const Login();
      //   //   }
      //   //   return const Home();
      //   // },
      //   '/profile': (context) => const Profile(),
      //   '/order': (context) => const Order(),
      //   '/tracker': (context) => const Tracker(),
      //   '/library': (context) => const Library(),
      // },
    ),
  );
}
