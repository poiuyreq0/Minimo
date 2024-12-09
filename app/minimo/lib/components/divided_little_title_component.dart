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
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: DividedElementComponent(
          title: title,
          content: content,
        ),
      ),
    );
  }
}
