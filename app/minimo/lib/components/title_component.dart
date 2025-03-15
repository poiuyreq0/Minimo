import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minimo/styles/app_style.dart';
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
                style: AppStyle.getLargeTextStyle(context),
              ),
              if (helpText.isNotEmpty)
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.circleQuestion,
                    color: Theme.of(context).colorScheme.tertiary,
                    size: 14,
                  ),
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
                ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                buttonText,
                style: AppStyle.getSmallTextStyle(context),
              ),
              if (buttonTextIcon != null)
                buttonTextIcon!,
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
