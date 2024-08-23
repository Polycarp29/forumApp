import 'package:flutter/material.dart';
import 'package:forum_app/constants/appconstants.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppConstants.gradientAppBar,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Text(
        'Lets Talk',
        style: GoogleFonts.roboto(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppConstants.grey,
          shadows: [
            const Shadow(
              blurRadius: 5.0,
              color: Colors.black45,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
      ),
      centerTitle: true,
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: AppConstants.lighterBlueShade,
          child: IconButton(
            icon: Icon(Icons.person, color: Colors.black),
            onPressed: () {
              // Navigate to user profile
            },
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(100); // Adjusted height to accommodate TabBar
}
