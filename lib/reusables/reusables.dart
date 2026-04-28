import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:training_apps/reusables/colors.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

Widget headingWidget(
  String title,
  IconData icon,
  VoidCallback onClick,
  BuildContext context,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Left Side: Title & Badge
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Industrial Icon Box (Replacing CircleAvatar)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10), // Modern rounded corners
            ),
            child: Icon(icon, size: 16, color: Colors.blueAccent),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title.toUpperCase(), // Professional uppercase look
                style: textStyle(
                  11,
                  Colors.blueAccent,
                  FontWeight.w900,
                  context: context,
                ).copyWith(letterSpacing: 1.2), // Added tracking
              ),
              const SizedBox(height: 2),
              // Optional Subtext indicator
              Container(
                height: 2,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ],
      ),

      // Right Side: Minimal Action Button
      InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black.withOpacity(0.05)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(
                "VIEW ALL",
                style: textStyle(
                  10,
                  Colors.black54,
                  FontWeight.w800,
                  context: context,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 10,
                color: Colors.black45,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

TextStyle textStyle(
  double? size,
  Color? color,
  FontWeight? weight, {
  BuildContext? context,
  double? height,
  FontStyle? fontStyle,
}) {
  final base = Theme.of(context!).textTheme.bodyMedium ?? const TextStyle();
  return base.copyWith(
    fontSize: size,
    color: color,
    fontWeight: weight,
    height: height ?? base.height,
    fontStyle: fontStyle ?? base.fontStyle,
  );
}

textBoxFocusBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide(color: MyColors.lightBlack, width: 1),
    borderRadius: BorderRadius.circular(50),
  );
}

sizedBoxHeight(double height) {
  return SizedBox(height: height);
}

sizedBoxWidth(double width) {
  return SizedBox(width: width);
}

textDecoration(String text) {
  return InputDecoration(
    isDense: true,
    counterText: '',
    hintText: text,
    border: const OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MyColors.red),
    ),
    disabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
  );
}

void showLoader() {
  Get.dialog(
    BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: PopScope(
        canPop: false, // Prevents back button from closing loader on Android
        child: Center(
          child: Platform.isIOS
              ? const CupertinoActivityIndicator(
                  radius: 15,
                  color: Colors.white,
                )
              : const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
        ),
      ),
    ),
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.4),
    useSafeArea: false, // Set to false for a full-screen blur
  );
}

void hideLoader() {
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }
}

SnackBar mySuccessSnackBar(String title, String message) {
  return SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,

    /// Ensures the design elements (like the bubbles) aren't cut off
    clipBehavior: Clip.none,

    /// Adds breathing room from the screen edges
    margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),

    /// Standard aesthetic timing (shorter feels snappier)
    duration: const Duration(milliseconds: 3500),

    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: ContentType.success,

      // Optional: Use Outlined variant if the package version supports it
      // for a more "Glassmorphism" or modern look
      // inSideState: true,
    ),
  );
}

SnackBar myErrorSnackBar(String title, String message) {
  return SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,

    // Crucial: prevents the 'X' icon or bubbles from being cropped
    clipBehavior: Clip.none,

    // Symmetrical padding for a balanced, floating tile look
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),

    // Errors usually need an extra second for the user to process
    duration: const Duration(seconds: 4),

    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: ContentType.failure, // 'failure' is the red error state
    ),
  );
}

SnackBar myWarningSnackBar(String title, String message) {
  return SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,

    // Allows the warning icon and design flourishes to overlap borders
    clipBehavior: Clip.none,

    // Floating margins create the "modern app" look
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: ContentType.warning,
      // help line: You can change the font style here if needed
    ),
  );
}

headingStyle() {
  return const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
}

headingBar() {
  return Container(height: 10, width: 3, color: Colors.black);
}

class StatusStyle {
  final Color bgColor;
  final Color textColor;
  final Color borderColor;

  StatusStyle({
    required this.bgColor,
    required this.textColor,
    required this.borderColor,
  });
}

StatusStyle getStatusStyle(String? status) {
  switch (status) {
    case 'Draft':
      return StatusStyle(
        bgColor: MyColors.draftBg,
        textColor: MyColors.draftText,
        borderColor: MyColors.draftBorder,
      );
    case 'Upcoming':
      return StatusStyle(
        bgColor: MyColors.upcomingBg,
        textColor: MyColors.upcomingText,
        borderColor: MyColors.upcomingBorder,
      );
    case 'Ongoing':
      return StatusStyle(
        bgColor: MyColors.ongoingBg,
        textColor: MyColors.ongoingText,
        borderColor: MyColors.ongoingBorder,
      );
    case 'Completed':
      return StatusStyle(
        bgColor: MyColors.completedBg,
        textColor: MyColors.completedText,
        borderColor: MyColors.completedBorder,
      );
    default:
      // Default fallback (Gray)
      return StatusStyle(
        bgColor: Colors.grey.shade50,
        textColor: Colors.grey.shade700,
        borderColor: Colors.grey.shade200,
      );
  }
}

String formatTime(String time) {
  try {
    // Parse the string "15:30" into a DateTime object
    // We use a dummy date because we only care about the time
    DateTime tempDate = DateFormat("HH:mm").parse(time);

    // Format it to "h:mm a" (3:30 PM)
    return DateFormat("h:mm a").format(tempDate);
  } catch (e) {
    return time; // Return original if parsing fails
  }
}

Widget appBarBackButton(BuildContext context) {
  return IconButton(
    onPressed: () => Get.back(),
    icon: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: const Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 18,
        color: Colors.black,
      ),
    ),
  );
}
