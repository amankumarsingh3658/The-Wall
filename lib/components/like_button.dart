// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  bool isLiked;
  void Function()? onTap;
  LikeButton({super.key, required this.isLiked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isLiked
          ? Icon(
              Icons.favorite,
              color: Colors.red,
            )
          : Icon(
              Icons.favorite_border_outlined,
              color: Colors.grey,
            ),
    );
  }
}
