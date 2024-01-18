import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String message, [Color? color]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color ?? Colors.black,
    ),
  );
}
