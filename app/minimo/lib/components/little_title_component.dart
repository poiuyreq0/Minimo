import 'package:flutter/material.dart';
import 'package:minimo/styles/app_style.dart';

class LittleTitleComponent extends StatelessWidget {
  final String title;
  final String? content;
  final VoidCallback? onPressed;

  const LittleTitleComponent({
    required this.title,
    this.content,
    this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                style: AppStyle.getMediumTextStyle(context),
              ),
            ),
            if (content != null)
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  content!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.getSmallTextStyle(context),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
