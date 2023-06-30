import 'package:diafit/pages/Order/menu.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:diafit/pages/home.dart';
import 'package:diafit/pages/Profile/profile.dart';
import 'package:diafit/pages/order.dart';
import 'package:diafit/pages/library.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  // final String? route;

  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  // final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // cupertino

    // halamanya berdasarkan posisi navbar itemnya
    List<Widget> _buildScreens() {
      return [
        const Profile(),
        const Menu(),
        const Home(),
        const Library(),
      ];
    }

    final PersistentTabController controller =
        PersistentTabController(initialIndex: 2);

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
            icon: const Icon(Icons.person),
            title: ("Profile"),
            activeColorPrimary: Theme.of(context).colorScheme.primary,
            inactiveColorPrimary: Colors.grey,
            routeAndNavigatorSettings: RouteAndNavigatorSettings(routes: {
              '/order': (context) => const Order(),
            })),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.receipt),
          title: ("Order"),
          activeColorPrimary: Theme.of(context).colorScheme.primary,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: ("Home"),
          activeColorPrimary: Theme.of(context).colorScheme.primary,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.book),
          title: ("Library"),
          activeColorPrimary: Theme.of(context).colorScheme.primary,
          inactiveColorPrimary: Colors.grey,
        ),
      ];
    }

    return PersistentTabView(
      context,
      controller: controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: false, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style13, // Choose the nav bar style with this property.
    );
  }

  // navbar item mana  yang harus dihighlight kalo lagi di halaman mana
  // login sama home itu home karena autologin

  //   if (widget.route == '/profile') {
  //     _selectedIndex = 0;
  //   } else if (widget.route == '/order') {
  //     _selectedIndex = 1;
  //   } else if (widget.route == '/login' || widget.route == '/home') {
  //     _selectedIndex = 2;
  //   } else if (widget.route == '/tracker') {
  //     _selectedIndex = 3;
  //   } else if (widget.route == '/library') {
  //     _selectedIndex = 4;
  //   }

  //   return BottomNavigationBar(
  //     type: BottomNavigationBarType.fixed,
  //     items: const [
  //       BottomNavigationBarItem(
  //         icon: Icon(
  //           Icons.person,
  //         ),
  //         label: 'Profile',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(
  //           Icons.receipt,
  //         ),
  //         label: 'Order',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(
  //           Icons.home,
  //         ),
  //         label: 'Home',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(
  //           Icons.health_and_safety,
  //         ),
  //         label: 'Tracker',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(
  //           Icons.book,
  //         ),
  //         label: 'Library',
  //       ),
  //     ],
  //     currentIndex: _selectedIndex,
  //     onTap: _onItemTapped,
  //   );
  // }

  // void _onItemTapped(int index) {
  //   if (index == 0) {
  //     Navigator.pushReplacementNamed(context, '/profile');
  //   } else if (index == 1) {
  //     Navigator.pushReplacementNamed(context, '/order');
  //   } else if (index == 2) {
  //     Navigator.pushReplacementNamed(context, '/home');
  //   } else if (index == 3) {
  //     Navigator.pushReplacementNamed(context, '/tracker');
  //   } else if (index == 4) {
  //     Navigator.pushReplacementNamed(context, '/library');
  //   }
  //   // setState(() {
  //   //   _selectedIndex = index;
  //   // });
  // }
}
