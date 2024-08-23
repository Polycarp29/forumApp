import 'package:flutter/material.dart';
import 'package:forum_app/appfiles/index.dart';
import 'package:get_storage/get_storage.dart';

// Redirects to the Index Home Usind Void main() Initializer
// void main() => runApp(const IndexHome());
void main() async {
  await GetStorage.init(); // Initialize GetStorage before running the app
  runApp(IndexHome());
}
