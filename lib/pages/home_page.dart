import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:thewall/components/text_fields.dart';
import 'package:thewall/components/wall_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // getting the current user
  final currentUser = FirebaseAuth.instance.currentUser;

  // Text controller for posts
  final postTextController = TextEditingController();

  // Sign out user
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void postMessage() async {
    // only post if there is something in the text Field
    if (postTextController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection("User Posts").add({
        "UserEmail": currentUser!.email,
        "Message": postTextController.text,
        "TimeStamp": DateTime.now(),
        "Likes": [],
      });
    }
    // Clear the text fields
    setState(() {
      postTextController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          "The Wall",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: signOut,
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                // The wall
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("User Posts")
                          .orderBy("TimeStamp", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                // Get the message
                                final post = snapshot.data!.docs[index];
                                return WallPost(
                                  message: post["Message"],
                                  userEmail: post["UserEmail"],
                                  postId: post.id,
                                  likes: List<String>.from(post["Likes"] ?? []),
                                );
                              });
                        } else {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("Error" + snapshot.error.toString()),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ),
                // Post A Message
                Row(
                  children: [
                    // Text Field
                    Expanded(
                      child: MyTextField(
                          controller: postTextController,
                          hintText: "Write something on the Wall....",
                          obsecure: false),
                    ),
                    // Post Button
                    IconButton(
                        onPressed: () => postMessage(),
                        icon: Icon(Icons.arrow_circle_up))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                // Logged in user
                Text(
                  "Logged in as : ${currentUser!.email}",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
