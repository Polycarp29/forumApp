import 'dart:convert';

import 'package:forum_app/appfiles/views/Pages/homepage/homepage.dart';
import 'package:forum_app/constants/appconstants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// API Controller
class AuthenticationController extends GetxController {
  // Create Is Loading

  final isLoading = false.obs;

  // Future<String?> register({
  //   required String username,
  //   required String name,
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     isLoading.value = true;
  //     final response = await http.post(
  //       Uri.parse('${AppConstants.baseUrl}/register'),
  //       headers: {'Accept': 'application/json'},
  //       body: jsonEncode({
  //         'username': username,
  //         'name': name,
  //         'email': email,
  //         'password': password,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       return data['token'];
  //     } else {
  //       print('Registration Failed: ${response.body}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('An error occurred: $e'); // Catch Errors With e
  //     return null;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<Map<String, dynamic>?> register({
    required String username,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/register'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'token': data['token']};
      } else {
        final errorData = jsonDecode(response.body);
        return {'errors': errorData['errors']};
      }
    } catch (e) {
      print('An error occurred: $e');
      return {
        'errors': {
          'general': ['An unexpected error occurred. Please try again later.']
        }
      };
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> login({
    required String username,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      var data = {'username': username, 'password': password};
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/login'),
        headers: {'Accept': 'application/json'},
        body: data,
      );

      isLoading.value = false;

      if (response.statusCode == 200 && response.body != null) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['token'] != null) {
          final token = responseBody['token'];

          // Store the token in GetStorage
          final box = GetStorage();
          box.write('token', token);

          print('Token saved: $token');

          Get.offAll(() => HomePage()); // Navigate to the HomePage
          return token; // Return the access token if needed
        } else {
          Get.snackbar(
            'Error',
            responseBody['message'] ?? 'Unknown error occurred',
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppConstants.redColor,
            colorText: AppConstants.white,
          );
          return null;
        }
      } else {
        Get.snackbar(
          'Error',
          response.body != null
              ? jsonDecode(response.body)['message'] ?? 'Unknown error'
              : 'Unknown error',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppConstants.redColor,
          colorText: AppConstants.white,
        );
        return null;
      }
    } catch (e) {
      isLoading.value = false;
      print('An error occurred: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppConstants.redColor,
        colorText: AppConstants.white,
      );
      return null;
    }
  }
}
