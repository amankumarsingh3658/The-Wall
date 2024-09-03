import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  void Function()? onPressed;
  String sectionName;
  String text;
  MyTextBox(
      {super.key,
      required this.sectionName,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 10, bottom: 10),
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  sectionName,
                  style: TextStyle(color: Colors.grey[500]),
                ),
                IconButton(
                    onPressed: onPressed,
                    icon: Icon(
                      Icons.edit,
                      color: Colors.grey[400],
                    ))
              ],
            ),
            // Text
            text.isEmpty
                ? Text("Empty Bio...", style: TextStyle(color: Colors.grey))
                : Text(text),
          ],
        ),
      ),
    );
  }
}
