import 'package:flutter/material.dart';
import 'package:forum_app/appfiles/views/Pages/homepage/homepage.dart';
import 'package:forum_app/appfiles/views/auth/login.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

class IndexHome extends StatelessWidget {
  const IndexHome({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final token = box.read('token'); // Read the token from storage
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Forum App',
      // Check if the token is null or empty
      home: token == null || token.isEmpty ? const LoginPage() : HomePage(),
    );
  }
}
