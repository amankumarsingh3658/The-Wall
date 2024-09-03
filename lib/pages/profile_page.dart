import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thewall/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // getting the current user
  final currentUser = FirebaseAuth.instance.currentUser;

  // collecting all users
  final userCollection = FirebaseFirestore.instance.collection("Users");

  // editing the field data
  Future<void> editField(String fieldName) async {
    String newValue = '';
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text(
                "Edit $fieldName",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              content: TextField(
                cursorColor: Colors.white,
                autofocus: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Update $fieldName",
                    hintStyle: TextStyle(color: Colors.grey)),
                onChanged: (value) {
                  newValue = value;
                },
              ),
              actions: [
                // cancel button
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    )),
                // Save button
                TextButton(
                    onPressed: () {
                      // Edit the New value in firestore
                      if (newValue.trim().length > 0) {
                        // Only update if there exist a value to be stored
                        userCollection
                            .doc(currentUser!.email)
                            .update({fieldName: newValue});
                      } else {
                        null;
                      }
                      Navigator.pop(context); // Popping out with the new value
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: Text("Profile Page"),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser!.email)
              .snapshots(),
          builder: (context, snapshot) {
            // if we have data
            if (snapshot.hasData) {
              // get the user data
              final userData = snapshot.data!.data();
              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Icon(
                        Icons.person,
                        size: 72,
                      ),
                    ),
                    Center(
                      child: Text(
                        currentUser!.email.toString(),
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "My Details",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    // UserName
                    MyTextBox(
                      sectionName: "Username",
                      text: userData!['username'],
                      onPressed: () => editField("username"),
                    ),
                    // User Bio
                    MyTextBox(
                      sectionName: "Bio",
                      text: userData['bio'],
                      onPressed: () => editField('bio'),
                    ),
                  ],
                ),
              );
              //
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            return Center(child: CircularProgressIndicator.adaptive());
          },
        ));
  }
}
