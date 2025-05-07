import 'package:flutter/material.dart';

class MYTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;

  const MYTextBox({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.yellow[700]!, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.yellow.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section name + edit icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: const TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.edit, color: Colors.yellow),
                tooltip: "Edit $sectionName",
              )
            ],
          ),
          const SizedBox(height: 6),
          // Main content
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
