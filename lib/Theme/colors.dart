// File: Themes/colors.dart

import 'package:flutter/material.dart';

// --- Original Theme Colors ---
// These colors are used throughout the app for buttons, text, accents etc.
Color buttonColor = const Color(0xffED3F40);        // Red used for buttons (like Past Orders, CustomButton default)
Color blackColor = Colors.black;             // Pure black (less common in UI, maybe for specific text)
Color? strikeThroughColor = Colors.grey[400]; // Grey for strikethrough text on completed items
Color newOrderColor = const Color(0xff009946);       // Original green color (used in home.dart example)
Color primaryColor = const Color(0xffFBAF03);       // Original yellow/orange accent color (used in home.dart example, theme primary)
Color textColor = const Color(0xff4D4D4D);         // Default dark grey text color for content on light backgrounds


// --- Order Status Colors for Kitchen Screen Timer ---
// These colors are specifically for the background of the order card header
// in the Kitchen Screen, changing based on elapsed time.

// Assigning values from existing theme colors for consistency:
const Color orderGreen = Color(0xff009946);   // Initial state (using the value of newOrderColor)
const Color orderYellow = Color(0xffFBAF03);  // Warning state (using the value of primaryColor)
const Color orderRed = Color(0xffED3F40);     // Urgent state (using the value of buttonColor)

/*
// --- Alternative Definitions (Uncomment if you need different shades) ---
// If the existing colors (newOrderColor, primaryColor, buttonColor) aren't the
// exact shades you want for the timer states, define new hex values here:

const Color orderGreen = Color(0xff2ECC71); // Example: A slightly different, brighter green
const Color orderYellow = Color(0xffF1C40F); // Example: A more pure yellow
const Color orderRed = Color(0xffE74C3C);   // Example: A slightly different red
*/