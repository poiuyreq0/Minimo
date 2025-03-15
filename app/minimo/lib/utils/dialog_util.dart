import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimo/styles/app_style.dart';

class DialogUtil {
  static Future<void> showCustomDialog({
    required BuildContext context,
    required String title,
    String? content,
    Widget? widgetContent,
    String? positiveText,
    VoidCallback? onPositivePressed,
    required String negativeText,
    required VoidCallback onNegativePressed,
    bool barrierDismissible = true,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: AppStyle.getLargeTextStyle(context),
          ),
          content: content != null ? Text(
            content,
            style: AppStyle.getMediumTextStyle(context),
          ) : widgetContent,
          actions: [
            TextButton(
              onPressed: onNegativePressed,
              child: Text(
                negativeText,
                style: AppStyle.getLittleButtonTextStyle(context, isPositive: false),
              ),
            ),
            if (positiveText != null)
              TextButton(
                onPressed: onPositivePressed,
                child: Text(
                  positiveText,
                  style: AppStyle.getLittleButtonTextStyle(context),
                ),
              ),
          ],
        );
      },
    );
  }
}