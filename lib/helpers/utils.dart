import 'package:flutter/material.dart';

class Utils {
  static void showSnack(BuildContext context, String message,
      {Color color = Colors.amber}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  static String formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}  ${date.hour}:${date.minute}";
  }
}
