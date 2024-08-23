import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forum_app/appfiles/views/Pages/favorites/favorites.dart';
import 'package:forum_app/appfiles/views/Pages/homepage/homepage.dart';
import 'package:forum_app/appfiles/views/Pages/profile/uprofile.dart';
import 'package:forum_app/appfiles/views/Pages/settings/settings.dart';
import 'package:forum_app/constants/appconstants.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  const BottomNavBar({
    super.key,
    required this.selectedIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    Widget page;
    switch (index) {
      case 0:
        page = HomePage();
        break;
      case 1:
        page = const FavoritesPage();
        break;
      case 2:
        page = const SettingsPage();
        break;
      case 3:
        page = const ProfilePage();
        break;
      default:
        page = HomePage();
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      height: 70,
      buttonBackgroundColor: AppConstants.darkGrey,
      backgroundColor: AppConstants.darkGrey,
      color: AppConstants.lighterBlueShade,
      animationDuration: const Duration(milliseconds: 400),
      index: selectedIndex, // Set the selected index here
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        Icon(
          CupertinoIcons.home,
          semanticLabel: 'Home',
        ),
        Icon(
          CupertinoIcons.heart,
          semanticLabel: 'Favorites',
        ),
        Icon(
          CupertinoIcons.settings,
          semanticLabel: 'Settings',
        ),
        Icon(
          CupertinoIcons.person,
          semanticLabel: 'Profile',
        ),
      ],
    );
  }
}
