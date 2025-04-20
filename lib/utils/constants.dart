import 'package:flutter/material.dart';

// App colors
const Color primaryColor = Colors.blue;
const Color secondaryColor = Colors.blueAccent;
const Color backgroundColor = Colors.white;

// Text styles
const TextStyle headingStyle = TextStyle(
  fontSize: 24.0, 
  fontWeight: FontWeight.bold,
);

const TextStyle bodyStyle = TextStyle(
  fontSize: 16.0,
);

const TextStyle buttonTextStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
);

// Padding
const double defaultPadding = 16.0;

// Input decoration
InputDecoration inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    filled: true,
    fillColor: Colors.grey[200],
  );
}

// Button style
final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: primaryColor,
  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
  ),
);