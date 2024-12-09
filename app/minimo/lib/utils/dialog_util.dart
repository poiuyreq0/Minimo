import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtil {
  static void showCustomDialog({
    required BuildContext context,
    String? title,
    String? content,
    Widget? widgetContent,
    String? positiveText,
    VoidCallback? onPositivePressed,
    required String negativeText,
    required VoidCallback onNegativePressed,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: title != null ? Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ) : null,
          content: content != null ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              content,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ) : widgetContent,
          actions: [
            if (positiveText != null)
              TextButton(
                onPressed: onPositivePressed,
                child: Text(
                  positiveText,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            TextButton(
              onPressed: onNegativePressed,
              child: Text(
                negativeText,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}