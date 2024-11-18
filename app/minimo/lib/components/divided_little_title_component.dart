import 'package:flutter/material.dart';

import 'divided_element_component.dart';

class DividedLittleTitleComponent extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback? onPressed;

  const DividedLittleTitleComponent({
    required this.title,
    String? content,
    this.onPressed,
    super.key
  })  : content = content ?? '';

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: DividedElementComponent(
          title: title,
          content: content,
        ),
      ),
    );
  }
}
