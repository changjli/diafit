import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:diafit/Landing/login.dart';

class RegisPage extends StatelessWidget {
  const RegisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Container(
                child: Image(
                  image: AssetImage("images/diafit.png"),
                ),
              ),
              SizedBox(height: 30),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(25),
                        label: Text("Username"),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          size: 25,
                          Icons.person_outline_rounded,
                          color: Colors.black,
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 157, 127, 168),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(25),
                        label: Text("Email"),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          size: 25,
                          Icons.mail_outline,
                          color: Colors.black,
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 157, 127, 168),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(25),
                        label: Text("Password"),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          size: 25,
                          LineAwesomeIcons.lock,
                          color: Colors.black,
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 157, 127, 168),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(25),
                        label: Text("Confirm Password"),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          size: 25,
                          LineAwesomeIcons.lock,
                          color: Colors.black,
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 157, 127, 168),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                child: ElevatedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 157, 127, 168),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 20),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   child: Text(
              //     "OR",
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       fontSize: 18,
              //       fontFamily: 'Montserrat',
              //       color: Color.fromARGB(255, 146, 146, 146),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 20),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   height: 70,
              //   child: ElevatedButton(
              //     onPressed: () {},
              //     style: OutlinedButton.styleFrom(
              //       side: BorderSide(
              //         width: 1,
              //         color: Colors.black,
              //       ),
              //       backgroundColor: Colors.white,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Container(
              //           child: Image(
              //             image: AssetImage("images/google-icon.png"),
              //             width: 30,
              //             fit: BoxFit.contain,
              //           ),
              //         ),
              //         SizedBox(width: 15),
              //         Text(
              //           "Sign-In with Google",
              //           style: TextStyle(
              //             fontSize: 20,
              //             fontFamily: 'Poppins',
              //             color: const Color.fromARGB(215, 0, 0, 0),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: AlignmentDirectional.center,
                child: TextButton(
                  onPressed: () => Get.to(() => const LoginPage()),
                  child: Text.rich(
                    TextSpan(
                      text: "Already have an Account? ",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                      ),
                      children: const [
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
