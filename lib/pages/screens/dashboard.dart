import 'package:faskes/models/user_model.dart';
import 'package:faskes/pages/screens/tabs/fav_faskes.dart';
import 'package:faskes/pages/screens/tabs/home.dart';
import 'package:faskes/pages/screens/tabs/profile.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Dashboard extends StatefulWidget {
  UserModel user;
  Dashboard({required this.user, super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens(String role) {
    List<Widget> screens = [];
    switch (role) {
      case "user":
        screens = [
          HomeScreen(
            user: widget.user,
          ),
          FavFaskesScreen(
            userModel: widget.user,
          ),
          ProfileScreen(
            user: widget.user,
          ),
        ];
      case "admin":
        screens = [
          HomeScreen(
            user: widget.user,
          ),
          ProfileScreen(
            user: widget.user,
          ),
        ];
    }

    return screens;
  }

  List<PersistentBottomNavBarItem> _navBarsItems(String role) {
    List<PersistentBottomNavBarItem> items = [];
    switch (role) {
      case "user":
        items = [
          PersistentBottomNavBarItem(
            icon: const Icon(Icons.home),
            title: "Beranda",
          ),
          PersistentBottomNavBarItem(
            icon: const Icon(Icons.favorite),
            title: "Favorit",
          ),
          PersistentBottomNavBarItem(
            icon: const Icon(Icons.person),
            title: "Profil",
          ),
        ];
      case "admin":
        items = [
          PersistentBottomNavBarItem(
            icon: const Icon(Icons.home),
            title: "Beranda",
          ),
          PersistentBottomNavBarItem(
            icon: const Icon(Icons.person),
            title: "Profil",
          ),
        ];
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(widget.user.role!),
      items: _navBarsItems(widget.user.role!),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
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
          NavBarStyle.style6, // Choose the nav bar style with this property.
    );
  }
}
