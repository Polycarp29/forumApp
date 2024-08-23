import 'package:flutter/material.dart';
import 'package:forum_app/appfiles/views/Pages/post/commentsPage.dart';
import 'package:forum_app/appfiles/views/Pages/post/posts.dart';
import 'package:forum_app/appfiles/views/Pages/post/postsEdit.dart';
import 'package:forum_app/appfiles/views/widgets/appbar.dart';
import 'package:forum_app/appfiles/views/widgets/curvednavBar.dart';
import 'package:forum_app/constants/appconstants.dart';
import 'package:forum_app/controllers/commentsController.dart';
import 'package:forum_app/controllers/createPostController.dart';
import 'package:forum_app/controllers/posts_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final PostsController _postsController = Get.put(PostsController());
  final CreatePost _createPost = Get.put(CreatePost());
  Color likedPost = AppConstants.darkerGrey;
  final TextEditingController _createPostController = TextEditingController();
  final Commentscontroller _commentscontroller = Get.put(Commentscontroller());
  late TabController _tabController;

  String? _createPostError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _createPostController.dispose();
    super.dispose();
  }

  Future<void> _savePost() async {
    final content = _createPostController.text.trim();
    setState(() {
      _createPostError =
          content.isEmpty ? 'Cannot post an empty message' : null;
    });

    if (_createPostError == null) {
      _createPost.isLoading.value = true; // Start loading indicator

      try {
        final accessToken = await _createPost.createPost(content: content);
        if (accessToken != null) {
          Get.snackbar(
            'Success',
            'Post created successfully!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppConstants.greenColor,
            colorText: AppConstants.white,
          );
          _createPostController
              .clear(); // Clear the input field after a successful post
          _postsController
              .getAllPosts(); // Refresh the posts list after posting
        } else {
          Get.snackbar(
            'Error',
            'Post creation failed. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppConstants.redColor,
            colorText: AppConstants.white,
          );
        }
      } catch (error) {
        Get.snackbar(
          'Error',
          'An unexpected error occurred. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstants.redColor,
          colorText: AppConstants.white,
        );
      } finally {
        _createPost.isLoading.value = false; // Stop loading indicator
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.darkGrey,
      appBar: CustomAppBar(tabController: _tabController),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                PostEditing(
                  hintText: 'What is on your mind?',
                  controller: _createPostController,
                  ObscureText: false,
                ),
                if (_createPostError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      _createPostError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 8),
                Obx(() => Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed:
                            _createPost.isLoading.value ? null : _savePost,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppConstants.blueAccent,
                        ),
                        child: _createPost.isLoading.value
                            ? const CircularProgressIndicator(
                                color: AppConstants.white,
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.send,
                                    color: AppConstants.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Post',
                                    style: GoogleFonts.roboto(
                                      color: AppConstants.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    )),
                const SizedBox(height: 8),
                Obx(() {
                  if (_postsController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (_postsController.posts.value.isEmpty) {
                    return const Center(child: Text('No posts available.'));
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: _postsController.posts.value.length,
                      itemBuilder: (context, index) {
                        final post = _postsController.posts.value[index];
                        final timePosted = calculateTimeAgo(post.createdAt!);
                        return PostCard(
                          owner: post.user?.name ?? 'Unknown',
                          timePosted: timePosted,
                          content: post.content!,
                          onCommentPressed: () => Get.to(() => PageComments(
                                post: post,
                              )),
                          onLikePressed: () async {
                            await _commentscontroller.LikeandUnlike(post.id);
                            _postsController.getAllPosts();
                          },
                          color: post.liked!
                              ? AppConstants.blueAccent
                              : AppConstants.black,
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          Center(child: Text('Categories Content')),
          Center(child: Text('Deals Content')),
          Center(child: Text('Profile Content')),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(
        selectedIndex: 0,
      ),
    );
  }
}

String calculateTimeAgo(DateTime date) {
  final duration = DateTime.now().difference(date);
  if (duration.inDays > 1) {
    return '${duration.inDays} days ago';
  } else if (duration.inHours > 1) {
    return '${duration.inHours} hours ago';
  } else if (duration.inMinutes > 1) {
    return '${duration.inMinutes} minutes ago';
  } else {
    return 'Just now';
  }
}
