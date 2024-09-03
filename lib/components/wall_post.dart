import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thewall/components/comment_button.dart';
import 'package:thewall/components/comments.dart';
import 'package:thewall/components/like_button.dart';
import 'package:thewall/helper/date_time_helper.dart';

// ignore: must_be_immutable
class WallPost extends StatefulWidget {
  String message;
  String userEmail;
  String postId;
  List<String> likes;
  String time;
  WallPost(
      {super.key,
      required this.message,
      required this.userEmail,
      required this.postId,
      required this.likes,
      required this.time});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  // Comment Text Controller
  final commentController = TextEditingController();

  // Get the user from the firebase
  final currentUser = FirebaseAuth.instance.currentUser;

  // Initially the post is unliked
  bool isLiked = false;
  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser!.email);
  }

  // Likes
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

  // Comments
  // add Comment
  void addComment(String comment) {
    // Adding the comment to the firestore under the comments collection
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "Comment": comment,
      "CommentBy": currentUser!.email,
      "TimeStamp": Timestamp.now()
    });
  }

  // Show A Dialog box for adding comment
  void showCommentDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text(
                "Add Comment",
                style: TextStyle(color: Colors.white),
              ),
              content: TextField(
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                autofocus: true,
                controller: commentController,
                decoration: InputDecoration(
                  focusColor: Colors.white,
                  hintText: "Add a Comment...",
                  hintStyle: TextStyle(color: Colors.grey[300]),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.white,
                  )),
                ),
              ),
              actions: [
                // Cancel Button
                TextButton(
                    onPressed: () {
                      commentController.clear();
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                // Save Button
                TextButton(
                  onPressed: () {
                    if (commentController.text.isNotEmpty) {
                      addComment(commentController.text);
                      commentController.clear();
                      Navigator.pop(context);
                      setState(() {});
                    } else {
                      commentController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Save"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.primary),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Profile pic
                Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey[400]),
                    child: Icon(Icons.person)),
                SizedBox(width: 15),
                // Message and User Email
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userEmail,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(widget.time,
                          style: TextStyle(color: Colors.grey[600])),
                      SizedBox(
                        height: 10,
                      ),
                      Text(widget.message),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        // Liked Icon
                        LikeButton(isLiked: isLiked, onTap: () => toggleLike()),
                        SizedBox(
                          height: 10,
                        ),
                        // Liked counter
                        Text(
                          widget.likes.length.toString(),
                          style: TextStyle(color: Colors.grey[600]),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        // Comment Icon
                        CommentButton(
                          onTap: () => showCommentDialog(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Comment counter
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("User Posts")
                                .doc(widget.postId)
                                .collection("Comments")
                                .snapshots(),
                            builder: (sontext, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: TextStyle(color: Colors.grey[600]),
                                );
                              } else {
                                return Text(
                                  "..",
                                  style: TextStyle(color: Colors.grey[600]),
                                );
                              }
                            })
                      ],
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Comments..",
              style: TextStyle(color: Colors.grey),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .orderBy("TimeStamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final comment = snapshot.data!.docs[index];
                          return Comment(
                              comment: comment["Comment"],
                              time: formatDate(comment["TimeStamp"]),
                              user: comment["CommentBy"]);
                          // Get The comments
                        });
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
