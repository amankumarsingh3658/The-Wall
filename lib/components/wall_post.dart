import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WallPost extends StatelessWidget {
  String message;
  String userEmail;
  WallPost({
    super.key,
    required this.message,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Row(
          children: [
            // Profile pic
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.grey[400]),
              child: Icon(Icons.person)
            ),SizedBox(width: 15),
            // Message and User Email
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userEmail,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(message),
              ],
            )
          ],
        ),
      ),
    );
  }
}
