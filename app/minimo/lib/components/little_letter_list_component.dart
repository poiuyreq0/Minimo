import 'package:flutter/material.dart';
import 'package:minimo/models/letter_element_model.dart';
import 'package:minimo/styles/app_style.dart';

import 'divided_element_component.dart';
import 'title_component.dart';

class LittleLetterListComponent extends StatelessWidget {
  final String title;
  final List<LetterElementModel> letters;
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
          buttonText: '유리병 건지기',
          onPressed: onPressed,
        ),
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          decoration: AppStyle.getMainBoxDecoration(Theme.of(context).colorScheme.onPrimary),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: letters.length,
            itemBuilder: (context, index) {
              return DividedElementComponent(
                title: letters[index].senderNickname,
                content: letters[index].title,
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8,);
            },
          ),
        ),
        const SizedBox(height: 16.0,),
      ],
    );
  }
}