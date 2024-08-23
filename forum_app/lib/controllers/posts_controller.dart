import 'dart:convert';

import 'package:forum_app/constants/appconstants.dart';
import 'package:forum_app/models/posts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// class PostsController extends GetxController {
//   Rx<List<PostsModel>> posts = Rx<List<PostsModel>>([]);
//   final isLoading = false.obs;
//   final box = GetStorage();

//   // Initiate Future to get all the posts
//   @override
//   void onInit() {
//     getAllPosts();
//     super.onInit();
//   }

//   Future getAllPosts() async {
//     // Catch any possible errors

//     try {
//       isLoading.value = true;
//       var response = await http.get(
//         Uri.parse('${AppConstants.baseUrl}/feeds'),
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer ${box.read('token')}',
//         },
//       );
//       if (response.statusCode == 200) {
//         // print(jsonDecode(response
//         //     .body)); // Print Response Body After authentication with Bearer auth
//         //Loop through posts
//         isLoading.value = false;
//         for (var item in jsonDecode(response.body)['feeds']) {
//           posts.value.add(PostsModel.fromJson(item));
//         }
//       } else {
//         isLoading.value = false;
//         print(jsonDecode(response.body));
//       }
//     } catch (e) {
//       isLoading.value = false;
//       print(e.toString());
//     }
//   }
// }

class PostsController extends GetxController {
  Rx<List<PostsModel>> posts = Rx<List<PostsModel>>([]);
  final isLoading = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    getAllPosts();
    super.onInit();
  }

  Future<void> getAllPosts() async {
    try {
      isLoading.value = true;
      final token = box.read('token');
      print('Token: $token');
      var response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/feeds'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['feeds'];
        posts.value =
            data.map<PostsModel>((item) => PostsModel.fromJson(item)).toList();
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
