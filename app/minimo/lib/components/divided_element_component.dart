import 'package:flutter/material.dart';

class DividedElementComponent extends StatelessWidget {
  final String title;
  final String content;

  const DividedElementComponent({
    required this.title,
    String? content,
    super.key
  })  : content = content ?? '';

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
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(width: 24,),
        Expanded(
          flex: 2,
          child: Text(
            content,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}
