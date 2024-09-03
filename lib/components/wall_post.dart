import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thewall/components/like_button.dart';

// ignore: must_be_immutable
class WallPost extends StatefulWidget {
  String message;
  String userEmail;
  String postId;
  List<String> likes;
  WallPost({
    super.key,
    required this.message,
    required this.userEmail,
    required this.postId,
    required this.likes,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  // Get the user from the firebase
  final currentUser = FirebaseAuth.instance.currentUser;
  // Initially the post is unliked
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser!.email);
  }

  // Toggle Like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    // save the data to firebase

    // Access the document in firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

    // If the post is liked add user to list
    if (isLiked) {
      postRef.update({
        "Likes": FieldValue.arrayUnion([currentUser!.email])
      });
    } else {
      postRef.update({
        "Likes": FieldValue.arrayRemove([currentUser!.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Row(
          children: [
            // Profile pic
            Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey[400]),
                child: Icon(Icons.person)),
            SizedBox(width: 15),
            // Message and User Email
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userEmail,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(widget.message),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                // Liked Icon
                LikeButton(isLiked: isLiked, onTap: () => toggleLike()),
                SizedBox(
                  height: 5,
                ),
                // Liked counter
                Text(
                  widget.likes.length.toString(),
                  style: TextStyle(color: Colors.grey[600]),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
