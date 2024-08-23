import 'package:flutter/material.dart';
import 'package:forum_app/appfiles/views/Pages/homepage/homepage.dart';
import 'package:forum_app/appfiles/views/Pages/post/posts.dart';
import 'package:forum_app/appfiles/views/widgets/curvednavBar.dart';
import 'package:forum_app/appfiles/views/widgets/otherpages.dart';
import 'package:forum_app/constants/appconstants.dart';
import 'package:forum_app/controllers/commentsController.dart';
import 'package:forum_app/controllers/posts_controller.dart';
import 'package:forum_app/models/posts.dart';
import 'package:get/get.dart';

class PageComments extends StatefulWidget {
  const PageComments({super.key, required this.post});
  final PostsModel post;

  @override
  State<PageComments> createState() => _PageCommentsState();
}

class _PageCommentsState extends State<PageComments> {
  Color likedPost = AppConstants.darkerGrey;
  final PostsController _postsController = Get.put(PostsController());
  final TextEditingController _commentPostController = TextEditingController();
  final Commentscontroller _commentscontroller = Get.put(Commentscontroller());
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false); // New line
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _commentPostController
        .addListener(_onTextChanged); // Listen to text changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _commentscontroller.getComments(widget.post.id);
    });
  }

  // Listen for text changes to update the button state
  void _onTextChanged() {
    _isButtonEnabled.value = _commentPostController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _commentPostController.removeListener(_onTextChanged);
    _commentPostController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PostCard(
                      owner: widget.post.user?.name ?? 'Unknown',
                      timePosted: calculateTimeAgo(widget.post.createdAt!),
                      content: widget.post.content!,
                      onCommentPressed: () async {
                        await _commentscontroller.LikeandUnlike(widget.post.id);
                        _postsController.getAllPosts();
                      },
                      color: widget.post.liked!
                          ? AppConstants.blueAccent
                          : AppConstants.black,
                    ),
                  ),
                  // Comments section using ListView.builder
                  Obx(() {
                    return _commentscontroller.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                _commentscontroller.comments.value.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color.fromARGB(
                                        255, 233, 240, 243),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/images/user.png'),
                                              maxRadius: 10,
                                              minRadius: 5,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              _commentscontroller.comments
                                                  .value[index].user!.name!,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _commentscontroller
                                              .comments.value[index].comment!,
                                          maxLines: isExpanded ? null : 3,
                                          overflow: isExpanded
                                              ? TextOverflow.visible
                                              : TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                  }),
                ],
              ),
            ),
            // Comment input and submit icon row
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppConstants.lightgrey,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppConstants.white, width: 0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentPostController,
                        decoration: const InputDecoration(
                          hintText: 'Write a comment...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable:
                          _isButtonEnabled, // Listen to button state
                      builder: (context, isEnabled, child) {
                        return IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: AppConstants.blueAccent,
                          ),
                          onPressed: isEnabled
                              ? () async {
                                  String comment =
                                      _commentPostController.text.trim();
                                  await _commentscontroller.addComment(
                                      widget.post.id, comment);
                                  _commentPostController.clear();
                                  _commentscontroller
                                      .getComments(widget.post.id);
                                }
                              : null, // Disable the button when input is empty
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(
        selectedIndex: 0,
      ),
    );
  }
}
