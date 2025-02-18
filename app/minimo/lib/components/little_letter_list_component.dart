import 'package:flutter/material.dart';
import 'package:minimo/components/images/net_icon_component.dart';
import 'package:minimo/models/simple_letter_model.dart';
import 'package:minimo/styles/app_style.dart';

import 'divided_element_component.dart';
import 'title_component.dart';

class LittleLetterListComponent extends StatelessWidget {
  final String title;
  final List<SimpleLetterModel> letters;
  final VoidCallback? onPressed;

  const LittleLetterListComponent({
    required this.title,
    required this.letters,
    required this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TitleComponent(
          title: title,
          buttonText: '유리병 건지기 ',
          buttonTextIcon: NetIconComponent(),
          onPressed: onPressed,
        ),
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          decoration: AppStyle.getMainBoxDecoration(context),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: letters.length,
            itemBuilder: (context, index) {
              return DividedElementComponent(
                title: letters[index].senderNickname,
                content: letters[index].title,
                fontSize: 14,
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
