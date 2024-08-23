import 'dart:convert';

import 'package:forum_app/constants/appconstants.dart';
import 'package:forum_app/models/commentsmodel.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class Commentscontroller extends GetxController {
  Rx<List<CommentsModel>> comments = Rx<List<CommentsModel>>([]);
  final isLoading = false.obs;
  final box = GetStorage();

  Future<void> getComments(id) async {
    try {
      comments.value.clear(); // Clear previous comments
      isLoading.value = true; // Start loading

      final token = box.read('token');
      var response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/feed/getcomments/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['comments'];
        List<CommentsModel> fetchedComments = [];
        for (var contents in data) {
          fetchedComments.add(CommentsModel.fromJson(contents));
        }
        comments.value = fetchedComments; // Update comments observable
      } else {
        print(jsonDecode(response.body)); // Handle non-200 status codes
      }
    } catch (e) {
      print('Exception: $e'); // Handle exception
    } finally {
      isLoading.value = false; // Stop loading in all cases
    }
  }

//   Future addComment(id, body) async {
// // Check for possible Errors using try
//     try {
//       isLoading.value = true;
//       // Start Loading
//       final token = box.read('token');
//       // Create a response
//       final response = await http.post(
//         Uri.parse('${AppConstants.baseUrl}/feed/comment/$id'),
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token'
//         },
//         body: jsonEncode({'body': body}),
//       );
//       if (response == 200) {
//         final data = response.body;
//         return data;
//       }
//     } catch (e) {
//       print('Exception $e');
//     }
//   }
  Future addComment(id, String body) async {
    try {
      isLoading.value = true;
      final token = box.read('token');

      // Create the response
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/feed/comment/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            {'comment': body}), // Ensure this matches API expectations
      );

      // Check for a successful response
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body); // Decode the JSON response
        return data;
      } else if (response.statusCode == 422) {
        // Log detailed error message
        print('Validation Error: ${response.body}');
        return null;
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    } finally {
      isLoading.value = false; // Ensure loading state is reset
    }
  }

  Future LikeandUnlike(id) async {
// catch exceptions
    try {
      String res = '';
      isLoading.value = true;
      final token = box.read('token');
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/feed/like/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200 ||
          jsonDecode(response.body)['message'] == 'Liked') {
        isLoading.value = false;
        print(jsonDecode(response.body));
      } else if (response.statusCode == 200 ||
          jsonDecode(response.body)['message'] == 'Unliked') {
        isLoading.value == false;
        print(jsonDecode(response.body));
      }
    } catch (e) {
      print('Error $e');
    }
  }
}
