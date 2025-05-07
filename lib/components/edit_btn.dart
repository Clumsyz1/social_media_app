import 'package:flutter/material.dart';

class EditBtn extends StatelessWidget {
  final void Function()? onTap;

  const EditBtn({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(
        Icons.edit,
        color: Colors.grey,
      ),
    );
  }
}
