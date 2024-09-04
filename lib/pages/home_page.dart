import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thewall/components/drawer.dart';

import 'package:thewall/components/text_fields.dart';
import 'package:thewall/components/wall_post.dart';
import 'package:thewall/helper/date_time_helper.dart';
import 'package:thewall/pages/profile_page.dart';

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

  Future<void> postMessage() async {
    // only post if there is something in the text Field
    if (postTextController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection("User Posts").add({
        "UserEmail": currentUser!.email,
        "Message": postTextController.text,
        "TimeStamp": DateTime.now(),
        "Likes": <String>[],
      });
    }
    // Clear the text fields
    setState(() {
      postTextController.clear();
    });
  }

  // go to profile Page
  void goToProfilePage() {
    // pop the drawer
    Navigator.pop(context);

    // go to profile page
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "The Wall",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                // The wall
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("User Posts")
                          .orderBy("TimeStamp", descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              reverse: false,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                // Get the message
                                final post = snapshot.data!.docs[index];
                                return WallPost(
                                  time: formatDate(post["TimeStamp"]),
                                  message: post["Message"],
                                  userEmail: post["UserEmail"],
                                  postId: post.id,
                                  likes: List<String>.from(
                                      post["Likes"] ?? <String>[]),
                                );
                              });
                        } else {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("Error${snapshot.error}"),
                            );
                          }
                          return const Center(
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
                        icon: const Icon(Icons.arrow_circle_up))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                // Logged in user
                Text(
                  "Logged in as : ${currentUser!.email}",
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        ),
      ),
      drawer: MyDrawer(
        onProfileTap: () => goToProfilePage(),
        onLogout: () => signOut(),
      ),
    );
  }
}
