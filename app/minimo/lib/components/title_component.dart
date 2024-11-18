import 'package:flutter/material.dart';

class TitleComponent extends StatelessWidget {
  final String title;
  final String buttonText;
  final String helpText;
  final VoidCallback? onPressed;

  const TitleComponent({
    required this.title,
    this.buttonText = '',
    this.helpText = '',
    this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (!helpText.isEmpty)
                IconButton(
                  iconSize: 16,
                  icon: Icon(Icons.help_outline),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              helpText,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                '닫기',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                buttonText,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              if (onPressed != null)
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
            ],
          )
        ],
      ),
    );
  }
}
