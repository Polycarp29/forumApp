import 'package:flutter/material.dart';
import 'package:forum_app/constants/appconstants.dart';

class PostCard extends StatefulWidget {
  final String owner;
  final String timePosted;
  final String content;
  final Color color;
  final VoidCallback?
      onLikePressed; // Callback for like button Paasing it in a widget
  final VoidCallback?
      onCommentPressed; // Callback for comment button Passing it in widget

  const PostCard({
    Key? key,
    required this.owner,
    required this.timePosted,
    required this.content,
    this.onLikePressed, // Accepting the like button callback
    this.onCommentPressed,
    required this.color, // Accepting the comment button callback
  }) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/user.png'),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.owner,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(widget.timePosted),
                ],
              ),
            ),
            Container(
              width: 500, // Adjust the width as needed
              height: 150, // Adjust the height as needed
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(8.0), // Optional: rounded corners
                child: Image.asset(
                  'assets/images/nft.jpg',
                  fit: BoxFit.cover, // Ensure the image still covers the space
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    widget.content,
                    maxLines: isExpanded ? null : 3,
                    overflow: isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                  ),
                  if (widget.content.length > 100)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Text(
                        isExpanded ? 'Read Less' : 'Read More',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: widget
                            .onLikePressed, // Handling the like button press
                        icon: Icon(
                          Icons.thumb_up,
                          color: widget.color,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: widget
                            .onCommentPressed, // Handling the comment button press
                        icon: Icon(Icons.comment),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
