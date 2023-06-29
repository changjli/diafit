import 'package:diafit/pages/Profile/edit_profile.dart';
import 'package:diafit/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:diafit/controller/custom_function.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            "Profile",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const Image(
                image: AssetImage('assets/images/image 5.png'),
              ),
              // Stack(
              //   children: [
              //     SizedBox(
              //       width: 170,
              //       height: 170,
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.circular(120),
              //         child: const Image(
              //             image: AssetImage("assets/images/profile.jpg")),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 240,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: const EditProfile(),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
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
              const Divider(
                height: 10,
                indent: 0,
                endIndent: 0,
                thickness: 1,
              ),
              InkWell(
                onTap: () {
                  CustomFunction.logout(
                    Navigator.of(context, rootNavigator: true).pushReplacement(
                        MaterialPageRoute(builder: (context) => const Login())),
                    id,
                  );
                },
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Theme.of(context).colorScheme.primary,
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
              ),
              const Divider(
                height: 10,
                indent: 0,
                endIndent: 0,
                thickness: 1,
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Theme.of(context).colorScheme.primary,
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
              const Divider(
                height: 10,
                indent: 0,
                endIndent: 0,
                thickness: 1,
              ),
            ],
          ),
        ),
      ),
    );

    // String? route = currentRoute();
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Profile'),
    //   ),
    //   body: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         Center(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               const SizedBox(
    //                 height: 30,
    //               ),
    //               const ProfilePicture(
    //                 name: 'Endang Sukendah',
    //                 radius: 50,
    //                 fontsize: 20,
    //               ),
    //               const SizedBox(
    //                 height: 10,
    //               ),
    //               Text(
    //                 'Endang Sukendah',
    //                 style: TextStyle(
    //                   color: Theme.of(context).colorScheme.primary,
    //                   fontSize: 18,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //               const SizedBox(height: 10),
    //               Text(
    //                 'EndangSukendah@gmail.com',
    //                 style: TextStyle(
    //                   color: Theme.of(context).colorScheme.primary,
    //                   fontSize: 14,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 30,
    //               ),
    //               Container(
    //                 height: MediaQuery.of(context).size.height,
    //                 width: MediaQuery.of(context).size.width,
    //                 padding: const EdgeInsets.all(30),
    //                 decoration: BoxDecoration(
    //                   shape: BoxShape.rectangle,
    //                   color: Theme.of(context).colorScheme.secondary,
    //                   borderRadius: BorderRadius.circular(30),
    //                 ),
    //                 child: Column(
    //                   children: [
    //                     Card(
    //                       color: Theme.of(context).colorScheme.secondary,
    //                       shadowColor: Colors.transparent,
    //                       elevation: 0,
    //                       clipBehavior: Clip.hardEdge,
    //                       shape: const RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.zero,
    //                       ),
    //                       child: Container(
    //                         padding: const EdgeInsets.all(10),
    //                         decoration: BoxDecoration(
    //                             border: Border(
    //                                 bottom: BorderSide(
    //                           color: Theme.of(context).colorScheme.primary,
    //                         ))),
    //                         child: InkWell(
    //                             onTap: () {
    //                               PersistentNavBarNavigator.pushNewScreen(
    //                                 context,
    //                                 screen: const BioData(),
    //                               );
    //                             },
    //                             child: Row(
    //                               mainAxisAlignment:
    //                                   MainAxisAlignment.spaceBetween,
    //                               crossAxisAlignment: CrossAxisAlignment.center,
    //                               children: [
    //                                 Row(
    //                                   children: [
    //                                     Icon(
    //                                       Icons.account_circle,
    //                                       size: 40,
    //                                       color: Theme.of(context)
    //                                           .colorScheme
    //                                           .onSecondary,
    //                                     ),
    //                                     const SizedBox(
    //                                       width: 10,
    //                                     ),
    //                                     Column(
    //                                       crossAxisAlignment:
    //                                           CrossAxisAlignment.start,
    //                                       children: [
    //                                         Text(
    //                                           'My Account',
    //                                           style: TextStyle(
    //                                             color: Theme.of(context)
    //                                                 .colorScheme
    //                                                 .onSecondary,
    //                                             fontSize: 14,
    //                                           ),
    //                                         ),
    //                                         Text(
    //                                           'Make Changes to your account',
    //                                           style: TextStyle(
    //                                             color: Theme.of(context)
    //                                                 .colorScheme
    //                                                 .onSecondary,
    //                                             fontSize: 12,
    //                                           ),
    //                                         )
    //                                       ],
    //                                     ),
    //                                   ],
    //                                 ),
    //                                 Icon(
    //                                   Icons.arrow_forward_ios,
    //                                   size: 30,
    //                                   color: Theme.of(context)
    //                                       .colorScheme
    //                                       .onSecondary,
    //                                 )
    //                               ],
    //                             )),
    //                       ),
    //                     ),
    //                     const SizedBox(
    //                       height: 10,
    //                     ),
    //                     Card(
    //                       color: Theme.of(context).colorScheme.secondary,
    //                       shadowColor: Colors.transparent,
    //                       elevation: 0,
    //                       clipBehavior: Clip.hardEdge,
    //                       shape: const RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.zero,
    //                       ),
    //                       child: Container(
    //                         padding: const EdgeInsets.all(10),
    //                         decoration: BoxDecoration(
    //                             border: Border(
    //                                 bottom: BorderSide(
    //                           color: Theme.of(context).colorScheme.primary,
    //                         ))),
    //                         child: InkWell(
    //                             onTap: () {
    //                               CustomFunction.logout(
    //                                 Navigator.of(context, rootNavigator: true)
    //                                     .pushReplacement(MaterialPageRoute(
    //                                         builder: (context) =>
    //                                             const Login())),
    //                                 id,
    //                               );
    //                             },
    //                             child: Row(
    //                               mainAxisAlignment:
    //                                   MainAxisAlignment.spaceBetween,
    //                               crossAxisAlignment: CrossAxisAlignment.center,
    //                               children: [
    //                                 Row(
    //                                   children: [
    //                                     Icon(
    //                                       Icons.logout,
    //                                       size: 40,
    //                                       color: Theme.of(context)
    //                                           .colorScheme
    //                                           .onSecondary,
    //                                     ),
    //                                     const SizedBox(
    //                                       width: 10,
    //                                     ),
    //                                     Column(
    //                                       crossAxisAlignment:
    //                                           CrossAxisAlignment.start,
    //                                       children: [
    //                                         Text(
    //                                           'Log out',
    //                                           style: TextStyle(
    //                                             color: Theme.of(context)
    //                                                 .colorScheme
    //                                                 .onSecondary,
    //                                             fontSize: 14,
    //                                           ),
    //                                         ),
    //                                         Text(
    //                                           'Get out of your account',
    //                                           style: TextStyle(
    //                                             color: Theme.of(context)
    //                                                 .colorScheme
    //                                                 .onSecondary,
    //                                             fontSize: 12,
    //                                           ),
    //                                         )
    //                                       ],
    //                                     ),
    //                                   ],
    //                                 ),
    //                                 Icon(
    //                                   Icons.arrow_forward_ios,
    //                                   size: 30,
    //                                   color: Theme.of(context)
    //                                       .colorScheme
    //                                       .onSecondary,
    //                                 )
    //                               ],
    //                             )),
    //                       ),
    //                     ),
    //                     const SizedBox(
    //                       height: 10,
    //                     ),
    //                     Card(
    //                       color: Theme.of(context).colorScheme.secondary,
    //                       shadowColor: Colors.transparent,
    //                       elevation: 0,
    //                       clipBehavior: Clip.hardEdge,
    //                       shape: const RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.zero,
    //                       ),
    //                       child: Container(
    //                         padding: const EdgeInsets.all(10),
    //                         decoration: BoxDecoration(
    //                             border: Border(
    //                                 bottom: BorderSide(
    //                           color: Theme.of(context).colorScheme.primary,
    //                         ))),
    //                         child: InkWell(
    //                             onTap: () {
    //                               debugPrint('Card tapped.');
    //                             },
    //                             child: Row(
    //                               mainAxisAlignment:
    //                                   MainAxisAlignment.spaceBetween,
    //                               crossAxisAlignment: CrossAxisAlignment.center,
    //                               children: [
    //                                 Row(
    //                                   children: [
    //                                     Icon(
    //                                       Icons.delete,
    //                                       size: 40,
    //                                       color: Theme.of(context)
    //                                           .colorScheme
    //                                           .onSecondary,
    //                                     ),
    //                                     const SizedBox(
    //                                       width: 10,
    //                                     ),
    //                                     Column(
    //                                       crossAxisAlignment:
    //                                           CrossAxisAlignment.start,
    //                                       children: [
    //                                         Text(
    //                                           'Delete Acccount',
    //                                           style: TextStyle(
    //                                             color: Theme.of(context)
    //                                                 .colorScheme
    //                                                 .onSecondary,
    //                                             fontSize: 14,
    //                                           ),
    //                                         ),
    //                                         Text(
    //                                           'Erase your account',
    //                                           style: TextStyle(
    //                                             color: Theme.of(context)
    //                                                 .colorScheme
    //                                                 .onSecondary,
    //                                             fontSize: 12,
    //                                           ),
    //                                         )
    //                                       ],
    //                                     ),
    //                                   ],
    //                                 ),
    //                                 Icon(
    //                                   Icons.arrow_forward_ios,
    //                                   size: 30,
    //                                   color: Theme.of(context)
    //                                       .colorScheme
    //                                       .onSecondary,
    //                                 )
    //                               ],
    //                             )),
    //                       ),
    //                     ),
    //                     const SizedBox(
    //                       height: 10,
    //                     ),
    //                   ],
    //                 ),
    //               )
    //               // Container(
    //               //     width: 395,
    //               //     height: 251,
    //               //     padding: const EdgeInsets.symmetric(
    //               //         vertical: 40, horizontal: 50),
    //               //     decoration: BoxDecoration(
    //               //         boxShadow: [
    //               //           BoxShadow(
    //               //             color: const Color.fromARGB(255, 73, 82, 243)
    //               //                 .withOpacity(0.25),
    //               //             offset: const Offset(0, 10),
    //               //             blurRadius: 10,
    //               //           ),
    //               //         ],
    //               //         border: Border.all(
    //               //           color: Colors.white,
    //               //         )),
    //               //     child: Column(
    //               //       children: const [
    //               //         Text(
    //               //           'My Account',
    //               //           style: TextStyle(
    //               //             fontSize: 16,
    //               //             color: Color(0xff3641B7),
    //               //             fontWeight: FontWeight.bold,
    //               //           ),
    //               //         ),
    //               //         Text(
    //               //           'Make changes to your account',
    //               //           style: TextStyle(
    //               //             fontSize: 12,
    //               //             color: Color(0xff3641B7),
    //               //             fontWeight: FontWeight.normal,
    //               //           ),
    //               //         ),
    //               //         Text(''),
    //               //         Text(''),
    //               //         Text(
    //               //           'Log Out',
    //               //           style: TextStyle(
    //               //             fontSize: 16,
    //               //             color: Color(0xff3641B7),
    //               //             fontWeight: FontWeight.bold,
    //               //           ),
    //               //         ),
    //               //         Text(
    //               //           'Get out of your account ',
    //               //           style: TextStyle(
    //               //             fontSize: 12,
    //               //             color: Color(0xff3641B7),
    //               //             fontWeight: FontWeight.normal,
    //               //           ),
    //               //         ),
    //               //         Text(
    //               //           'Remove Account ',
    //               //           style: TextStyle(
    //               //             fontSize: 16,
    //               //             color: Color(0xff3641B7),
    //               //             fontWeight: FontWeight.bold,
    //               //           ),
    //               //         ),
    //               //         Text(
    //               //           'Remove Your Account ',
    //               //           style: TextStyle(
    //               //             fontSize: 12,
    //               //             color: Color(0xff3641B7),
    //               //             fontWeight: FontWeight.normal,
    //               //           ),
    //               //         ),
    //               //       ],
    //               //     ))
    //             ],
    //           ),
    //         ),
    //         // ElevatedButton(
    //         //   onPressed: () {
    //         //     PersistentNavBarNavigator.pushNewScreen(
    //         //       context,
    //         //       screen: const BioData(),
    //         //     );
    //         //   },
    //         //   child: const Text('Bio Data'),
    //         // ),
    //         // ElevatedButton(
    //         //   onPressed: () => CustomFunction.logout(
    //         //     // cupertino
    //         //     // PersistentNavBarNavigator.pushNewScreen(
    //         //     //   context,
    //         //     //   screen: const Login(),
    //         //     //   withNavBar: true, // OPTIONAL VALUE. True by default.
    //         //     //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
    //         //     // ),

    //         //     // owh ini jadi refer ke root
    //         //     // keluar dari CustomNavigationBar
    //         //     Navigator.of(context, rootNavigator: true).pushReplacement(
    //         //         MaterialPageRoute(builder: (context) => const Login())),
    //         //     id,
    //         //   ),

    //         //   // logout before refactor
    //         //   // () async {
    //         //   //   //   SharedPreferences pref = await SharedPreferences.getInstance();

    //         //   //   //   pref.remove("login");
    //         //   //   //   pref.remove("api_token");

    //         //   //   //   Navigator.pushReplacementNamed(context, '/login');
    //         //   //   // },
    //         //   child: const Text('Logout'),
    //         // ),
    //         // ElevatedButton(
    //         //   onPressed: () {
    //         //     // PersistentNavBarNavigator.pushNewScreen(
    //         //     //   context,
    //         //     //   screen: const Order(),
    //         //     //   withNavBar: true,
    //         //     // );
    //         //     Navigator.pushNamed(context, '/order');
    //         //   },
    //         //   child: const Text('Order'),
    //         // )
    //       ],
    //     ),
    //   ),
    //   // bottomNavigationBar: CustomBottomNavigationBar(
    //   //   route: route,
    //   // ),
    // );
  }
}
