import 'package:flutter/material.dart';


InputDecoration inputFieldStyles(String labelText) {
  return InputDecoration(
    labelText: labelText,
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white), // Set border color when focused
    ),
    labelStyle: const TextStyle(color: Colors.white), // Set label (placeholder) text color
  );
}
