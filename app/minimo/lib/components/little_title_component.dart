import 'package:flutter/material.dart';

class LittleTitleComponent extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const LittleTitleComponent({
    required this.title,
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
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
