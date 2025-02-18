import 'package:flutter/material.dart';
import 'package:minimo/components/images/user_network_image_component.dart';
import 'package:minimo/enums/letter_state.dart';
import 'package:minimo/enums/user_role.dart';
import 'package:minimo/models/letter_model.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/screens/home/letter_box/letter_detail_screen.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/time_stamp_util.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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
    final userId = context.read<UserProvider>().userCache!.id;

    final displayUser = _getDisplayUser(context);
    final displayUserRole = displayUser.item1;
    final displayUserId = displayUser.item2;
    final displayUserNickname = displayUser.item3;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LetterDetailScreen(letter: letter, userRole: userRole),)
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            UserNetworkImageComponent(
              userId: displayUserId,
              size: 55,
              cache: false,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Builder(
                    builder: (context) {
                      String result = (displayUserRole == UserRole.SENDER ? 'From. ' : 'To. ')
                          + (displayUserNickname ?? '(알 수 없음)');

                      return Text(
                        result,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.getLargeTextStyle(context, 16),
                      );
                    }
                  ),
                  const SizedBox(height: 5),
                  Text(
                    letter.letterContent.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyle.getMediumTextStyle(context, 14),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Builder(
                  builder: (context) {
                    late final String result;

                    if (letter.letterState == LetterState.CONNECTED) {
                      result = TimeStampUtil.getElementTimeStamp(letter.connectedDate!);
                    } else if (letter.letterState == LetterState.RECEIVED) {
                      result = TimeStampUtil.getElementTimeStamp(letter.receivedDate!);
                    } else {
                      result = TimeStampUtil.getElementTimeStamp(letter.createdDate!);
                    }

                    return Text(
                      result,
                      maxLines: 1,
                      style:AppStyle.getSmallTextStyle(context, 12),
                    );
                  },
                ),
                // 안 읽은 메시지 개수 추가
              ],
            ),
          ],
        ),
      ),
    );
  }

  Tuple3<UserRole, int?, String?> _getDisplayUser(BuildContext context) {
    final userId = context.read<UserProvider>().userCache!.id;
    late final UserRole displayUserRole;

    if (userRole == UserRole.SENDER && letter.letterState == LetterState.SENT) {
      displayUserRole = UserRole.SENDER;
    } else {
      if (letter.senderId != userId) {
        displayUserRole = UserRole.SENDER;
      } else {
        displayUserRole = UserRole.RECEIVER;
      }
    }

    if (displayUserRole == UserRole.SENDER) {
      return Tuple3(displayUserRole, letter.senderId, letter.senderNickname);
    } else {
      return Tuple3(displayUserRole, letter.receiverId, letter.receiverNickname);
    }
  }
}
