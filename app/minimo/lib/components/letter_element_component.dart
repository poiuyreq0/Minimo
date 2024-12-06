import 'package:flutter/material.dart';
import 'package:minimo/consts/user_role.dart';
import 'package:minimo/models/letter_model.dart';
import 'package:minimo/screens/home/letter_box/letter_detail_screen.dart';

class LetterElementComponent extends StatelessWidget {
  final LetterModel letter;
  final UserRole userRole;

  const LetterElementComponent({
    required this.letter,
    required this.userRole,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LetterDetailScreen(letter: letter, userRole: userRole),)
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              letter.letterContent.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 2,),
            Text(
              letter.letterContent.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 2,),
            Row(
              children: [
                Text(
                  'From ${letter.senderNickname ?? 'Unknown'} To ${letter.receiverNickname ?? 'Unknown'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
