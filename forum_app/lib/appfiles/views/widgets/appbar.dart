import 'package:flutter/material.dart';
import 'package:forum_app/constants/appconstants.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  CustomAppBar({required this.tabController});

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
      bottom: TabBar(
        controller: tabController,
        indicatorColor: AppConstants.black,
        indicatorWeight: 5.0, // Thickness of the tab indicator
        labelColor: AppConstants.black, // Color of the selected tab text
        unselectedLabelColor:
            AppConstants.black, // Color of the unselected tab text
        labelStyle: GoogleFonts.roboto(
          color: AppConstants.black,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
        tabs: [
          Tab(
            text: 'Feeds',
          ),
          Tab(text: 'Following'),
          Tab(text: 'Groups'),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(120); // Adjusted height to accommodate TabBar
}
