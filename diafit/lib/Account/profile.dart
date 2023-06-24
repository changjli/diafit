import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diafit/Account/edit_profile.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(LineAwesomeIcons.angle_left),
          color: Colors.black,
        ),
        title: const Center(
          child: Text(
            "Profile",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
            color: Colors.black,
          )
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(120),
                      child:
                          const Image(image: AssetImage("images/profile.jpg")),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Diafit's Admin",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                ),
              ),
              const Text(
                "diafit.Admin@gmail.com",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  color: Color.fromARGB(159, 0, 0, 0),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 240,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const EditProfile()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 190, 103, 193),
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    "Edit Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color.fromARGB(255, 198, 119, 230),
                  ),
                  child: const Icon(
                    LineAwesomeIcons.user,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  "My Account",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: const Color.fromARGB(255, 198, 119, 230),
                  ),
                  child: const Icon(
                    LineAwesomeIcons.angle_right,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color.fromARGB(255, 198, 119, 230),
                  ),
                  child: const Icon(
                    LineAwesomeIcons.alternate_sign_out,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  "Log Out",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color.fromARGB(255, 198, 119, 230),
                  ),
                  child: const Icon(
                    LineAwesomeIcons.trash_restore,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  "Delete Account",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
