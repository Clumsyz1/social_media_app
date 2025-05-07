import 'package:flutter/material.dart';

class LikeBotton extends StatelessWidget {
  final bool isliked;
  void Function()? onTap;

  LikeBotton({super.key, required this.isliked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isliked ? Icons.favorite : Icons.favorite_border,
        color: isliked ? Colors.red : Colors.grey,
      ),
    );
  }
}
