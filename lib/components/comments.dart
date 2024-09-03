import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  String comment;
  String user;
  String time;


  Comment(
      {super.key,
      required this.comment,
      required this.time,
      required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.grey[300]),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Comment
              Text(comment),
              SizedBox(
                height: 2,
              ),
              // User , Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    user,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    time,
                    style: TextStyle(color: Colors.blueGrey[300]),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
