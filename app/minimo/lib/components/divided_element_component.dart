import 'package:flutter/material.dart';
import 'package:minimo/styles/app_style.dart';

class DividedElementComponent extends StatelessWidget {
  final String title;
  final String content;
  final double fontSize;

  const DividedElementComponent({
    required this.title,
    required this.content,
    required this.fontSize,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyle.getDividedElementTextStyle(context, fontSize, isTitle: true),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Text(
            content,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyle.getDividedElementTextStyle(context, fontSize, isTitle: false),
          ),
        ),
      ],
    );
  }
}
