import 'package:flutter/material.dart';
import 'package:diafit/controller/custom_function.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: () => CustomFunction.logout(
            Navigator.pushReplacementNamed(context, '/login')),
        // () async {
        //   //   SharedPreferences pref = await SharedPreferences.getInstance();

        //   //   pref.remove("login");
        //   //   pref.remove("api_token");

        //   //   Navigator.pushReplacementNamed(context, '/login');
        //   // },
        child: const Text('logout'),
      ),
    );
  }
}
