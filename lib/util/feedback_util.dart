import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FeedbackUtil {
  FeedbackUtil._();

  static void showError(String message) {
    EasyLoading.showError(message);
  }

  static void showSuccess(String message) {
    EasyLoading.showSuccess(message);
  }

  static void showInfo(String message) {
    EasyLoading.showInfo(message);
  }

  static void showLoading(String message) {
    EasyLoading.show(status: message);
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
