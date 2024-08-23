import 'dart:convert';

import 'package:get/get.dart';
import 'package:forum_app/constants/appconstants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class CreatePost extends GetxController {
  final isLoading = false.obs;
  final box = GetStorage();

  Future createPost({
    required String content,
  }) async {
    try {
      isLoading.value = true;

      // Retrieve token from GetStorage
      final token = box.read('token');
      if (token == null) {
        print('Token not found');
        return null;
      }

      // Make the POST request
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/feed/save'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'content': content,
        }),
      );

      // Handle the response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data; // Make sure this key exists in the response
      } else {
        print(
            'Post Creation Failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e, stacktrace) {
      print('An Error Occurred: $e\nStacktrace: $stacktrace');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
