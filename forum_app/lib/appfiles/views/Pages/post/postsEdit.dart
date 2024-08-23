import 'package:flutter/material.dart';
import 'package:forum_app/constants/appconstants.dart';

class PostEditing extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool ObscureText;

  const PostEditing({
    super.key,
    required this.hintText,
    required this.controller,
    required this.ObscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppConstants.lighterBlueShade,
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
              obscureText: ObscureText,
              controller: controller,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: hintText)),
        ));
  }
}
