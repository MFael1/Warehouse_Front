import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarUtils {
  static void showCustomSnackbar({
    required String title,
    required String message,
    Color backgroundColor = Colors.red,
    TextStyle? titleTextStyle,
    TextStyle? messageTextStyle,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.rawSnackbar(
      title: title,
      message: message,
      backgroundColor: backgroundColor,
      titleText:
          titleTextStyle != null ? Text(title, style: titleTextStyle) : null,
      messageText: messageTextStyle != null
          ? Text(message, style: messageTextStyle)
          : null,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      snackPosition: SnackPosition.BOTTOM,
      duration: duration,
    );
  }
}
