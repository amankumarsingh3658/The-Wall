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
            borderRadius: BorderRadius.circular(8), color: Theme.of(context).colorScheme.secondary),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Comment
              Text(comment),
              const SizedBox(
                height: 2,
              ),
              // User , Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    user,
                    style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
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
