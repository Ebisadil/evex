import 'package:flutter/material.dart';

Widget buildimagecontainer(
  Color bgColor,
  String title,
  String subtitle,
  String imagePath,
) {
  return Container(
    color: bgColor,
    padding: const EdgeInsets.symmetric(horizontal: 30),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Image
        Image.asset(
          imagePath,
          height: 400,
          width: 400,
          fit: BoxFit.cover,
        ),

        const SizedBox(height: 20),

        // Title
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 15),

        // Subtitle
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            height: 1.4,
          ),
        ),
      ],
    ),
  );
}
