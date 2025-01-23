import 'package:flutter/material.dart';
import 'package:minimo/utils/dialog_util.dart';

class TitleComponent extends StatelessWidget {
  final String title;
  final String buttonText;
  final Widget? buttonTextIcon;
  final String helpText;
  final VoidCallback? onPressed;

  const TitleComponent({
    required this.title,
    this.buttonText = '',
    this.buttonTextIcon,
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
              if (helpText.isNotEmpty)
                IconButton(
                  iconSize: 16,
                  icon: Icon(Icons.help_outline),
                  onPressed: () {
                    DialogUtil.showCustomDialog(
                      context: context,
                      title: title,
                      content: helpText,
                      negativeText: '닫기',
                      onNegativePressed: () {
                        Navigator.of(context).pop();
                      },
                    );
                  },
                )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: buttonText,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (buttonTextIcon != null)
                      WidgetSpan(child: buttonTextIcon!),
                  ],
                ),
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
