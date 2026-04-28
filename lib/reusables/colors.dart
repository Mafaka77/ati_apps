import 'package:flutter/material.dart';

class MyColors {
  static Color white = const Color(0xFFFFFFFF);
  static Color green = const Color(0xff24b897);
  static Color lightGreen = const Color(0xffeff6f2);
  static Color lightBlack = const Color.fromARGB(255, 8, 8, 8);
  static Color limeGreen = const Color(0x0ff1fffc);
  static Color lightBlue = const Color(0xff44d7e9);
  static Color deepBlue = const Color(0xffd3e9ef);
  static Color orange = const Color(0xfff86d1c);
  static Color lightOrange = const Color(0xffff605d);
  static Color superLightOrange = const Color(0xffffe8e8);
  static Color red = const Color(0xffad1356);
  static Color buttonColor = const Color.from(
    alpha: 1,
    red: 0.647,
    green: 0.839,
    blue: 0.655,
  );
  static const Color card_background = Color(0xFFF6F6F6); // Light Grey
  static const Color home_background = Color(0xFFF1F5F9);
  static const Color upcoming = Color(0xFF42A5F5);
  static const Color ongoing = Color(0xFF66BB6A);
  static const Color finished = Color(0xFF9E9E9E);

  // Primaries (for icons / filled badges)
  static const Color statusUpcoming = Color(0xFF42A5F5); // Blue 400
  static const Color statusOngoing = Color(0xFF66BB6A); // Green 400
  static const Color statusFinished = Color(0xFF9E9E9E); // Grey 500

  // Light background variants (for subtle chips / pill backgrounds)
  static const Color statusUpcomingBg = Color(0xFFE3F2FD); // Light Blue
  static const Color statusOngoingBg = Color(0xFFE8F5E9); // Light Green
  static const Color statusFinishedBg = Color(0xFFF5F5F5); // Very Light Grey
  // Primary colors (for icon, border, or filled badge)
  static const Color statusOpen = Color(0xFF2196F3); // Blue 500  - Open
  static const Color statusInProgress = Color(
    0xFFFFA726,
  ); // Orange 400 - In Progress
  static const Color statusResolved = Color(
    0xFF66BB6A,
  ); // Green 400  - Resolved
  static const Color statusClosed = Color(0xFF9E9E9E); // Grey 500   - Closed

  // Lighter background variants (for chips, pill backgrounds)
  static const Color bgOpen = Color(0xFFE3F2FD); // Light Blue
  static const Color bgInProgress = Color(0xFFFFF3E0); // Light Orange
  static const Color bgResolved = Color(0xFFE8F5E9); // Light Green
  static const Color bgClosed = Color(0xFFF5F5F5); // Light Grey (very subtle)
  // Primary colors (for icons, filled badges)
  static const Color priorityLow = Color(0xFF66BB6A); // Green 400 - Low
  static const Color priorityMedium = Color(0xFFFFA726); // Orange 400 - Medium
  static const Color priorityHigh = Color(0xFFE53935); // Red 600    - High

  // Lighter background variants (for chips / pill backgrounds)
  static const Color bgPriorityLow = Color(0xFFE8F5E9); // Light Green
  static const Color bgPriorityMedium = Color(0xFFFFF3E0); // Light Orange
  static const Color bgPriorityHigh = Color(0xFFFFEBEE); // Light Red]

  // --- Status: Draft (Amber) ---
  static const Color draftBg = Color(0xFFFFFBEB); // amber-50
  static const Color draftText = Color(0xFFD97706); // amber-600
  static const Color draftBorder = Color(0xFFFEF3C7); // amber-100

  // --- Status: Upcoming (Red) ---
  static const Color upcomingBg = Color(0xFFFEF2F2); // red-50
  static const Color upcomingText = Color(0xFFDC2626); // red-600
  static const Color upcomingBorder = Color(0xFFFEE2E2); // red-100

  // --- Status: Ongoing (Blue) ---
  static const Color ongoingBg = Color(0xFFEFF6FF); // blue-50
  static const Color ongoingText = Color(0xFF2563EB); // blue-600
  static const Color ongoingBorder = Color(0xFFDBEAFE); // blue-100

  // --- Status: Completed (Emerald) ---
  static const Color completedBg = Color(0xFFECFDF5); // emerald-50
  static const Color completedText = Color(0xFF059669); // emerald-600
  static const Color completedBorder = Color(0xFFD1FAE5); // emerald-100
}
