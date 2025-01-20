import 'package:flutter/material.dart';

class SnackBarUtil {
  static void showCustomSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static void showCustomWidgetSnackBar({
    required BuildContext context,
    required Widget content,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: content),
    );
  }

  static void showCommonErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('요청 처리 중 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요.')),
    );
  }
}