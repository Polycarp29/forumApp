import 'package:flutter/material.dart';

class TexfieldWidget extends StatelessWidget {
  final String hint;
  final Color inputColor;
  final IconData iconData;
  final Color iconColor;
  final TextEditingController controller;
  final bool obscureText;

  const TexfieldWidget({
    super.key,
    required this.hint,
    required this.iconData,
    required this.inputColor,
    required this.iconColor,
    required this.controller,
    required this.obscureText,
    IconButton? suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 10), // Add vertical margin for spacing
      decoration: BoxDecoration(
        color: inputColor,
        borderRadius: BorderRadius.circular(15), // Smooth rounded corners
        boxShadow: const [
          BoxShadow(
            color: Colors.black12, // Subtle shadow
            offset: Offset(0, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: iconColor), // Text color matches icon color
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                15), // Match the container's border radius
            borderSide: BorderSide.none, // Remove default border
          ),
          hintText: hint,
          hintStyle:
              TextStyle(color: Colors.grey[600]), // Slightly darker hint text
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          prefixIcon: Icon(iconData, color: iconColor),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: iconColor,
                width: 1.5), // Highlighted border when focused
          ),
        ),
      ),
    );
  }
}
