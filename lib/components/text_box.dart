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
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 10, bottom: 10),
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.secondary),
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
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                ),
                IconButton(
                    onPressed: onPressed,
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.tertiary,
                    ))
              ],
            ),
            // Text
            text.isEmpty
                ? Text("Have a Great Start to your Bio...",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary))
                : Text(
                    text,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiaryFixed),
                  ),
          ],
        ),
      ),
    );
  }
}
