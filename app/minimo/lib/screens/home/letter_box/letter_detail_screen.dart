import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimo/enums/letter_state.dart';
import 'package:minimo/enums/user_role.dart';
import 'package:minimo/models/letter_model.dart';
import 'package:minimo/models/user_model.dart';
import 'package:minimo/models/user_role_model.dart';
import 'package:minimo/providers/chat_provider.dart';
import 'package:minimo/providers/letter_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/screens/chat/chat_room_screen.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/snack_bar_util.dart';
import 'package:minimo/utils/time_stamp_util.dart';
import 'package:provider/provider.dart';

class LetterDetailScreen extends StatelessWidget {
  final LetterModel letter;
  final UserRole userRole;

  const LetterDetailScreen({
    required this.letter,
    required this.userRole,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('유리병 편지'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                decoration: AppStyle.getMainBoxDecoration(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        letter.letterContent.title,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        letter.letterContent.content,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Divider(
                        height: 36,
                      ),
                      Text(
                        '보낸 사람   ${letter.senderNickname ?? '(알 수 없음)'}\n받은 사람   ${letter.receiverNickname ?? '(알 수 없음)'}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const Divider(
                        height: 36,
                      ),
                      if (letter.createdDate != null)
                        Text(
                          '보낸 일시   ${TimeStampUtil.getLetterTimeStamp(letter.createdDate!)}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      if (letter.receivedDate != null)
                        Text(
                          '받은 일시   ${TimeStampUtil.getLetterTimeStamp(letter.receivedDate!)}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      if (letter.connectedDate != null)
                        Text(
                          '연결 일시   ${TimeStampUtil.getLetterTimeStamp(letter.connectedDate!)}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ActionButton(letter: letter, letterState: letter.letterState!, userRole: userRole,),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final LetterModel letter;
  final LetterState letterState;
  final UserRole userRole;

  const ActionButton({
    required this.letter,
    required this.letterState,
    required this.userRole,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    LetterProvider letterProvider = context.read<LetterProvider>();
    UserModel user = context.read<UserProvider>().userCache!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (letterState == LetterState.CONNECTED || letterState == LetterState.LOCKED && userRole == UserRole.RECEIVER)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              style: AppStyle.getPositiveElevatedButtonStyle(context),
              onPressed: () async {
                // 편지 연결
                if (letterState != LetterState.CONNECTED) {
                  try {
                    await letterProvider.connectLetter(id: letter.id, userRoleModel: UserRoleModel(id: user.id, userRole: userRole));
                    Navigator.of(context).pop();
                    SnackBarUtil.showCustomSnackBar(context, '연결에 성공했습니다!\n상대방과 대화를 시작해 보세요.');

                  } catch (e) {
                    if (e is DioException && e.response?.statusCode == HttpStatus.notFound) {
                      SnackBarUtil.showCustomSnackBar(context, '연결이 끊긴 상대방입니다.\n편지를 연결할 수 없습니다.');
                    } else if (e is DioException && e.response?.statusCode == HttpStatus.forbidden) {
                      SnackBarUtil.showCustomSnackBar(context, '유효한 사용자가 아닙니다.');
                    } else {
                      SnackBarUtil.showCommonErrorSnackBar(context);
                    }
                    
                    // 연결 실패 시 종료
                    return ;
                  }
                }

                // 채팅방 이동
                try {
                  // 편지와 연결된 채팅방 Id 가져오기
                  final chatRoomId = await context.read<ChatProvider>().getChatRoomIdByLetterId(letterId: letter.id);

                  final otherUserNickname = userRole == UserRole.SENDER ? letter.senderNickname : letter.receiverNickname;

                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ChatRoomScreen(id: chatRoomId, userId: user.id, otherUserNickname: otherUserNickname!,),)
                  );

                } catch (e) {
                  if (e is DioException && e.response?.statusCode == HttpStatus.notFound) {
                    SnackBarUtil.showCustomSnackBar(context, '사라진 채팅방입니다.');
                  } else {
                    SnackBarUtil.showCommonErrorSnackBar(context);
                  }
                }
              },
              child: Builder(
                builder: (context) {
                  if (letterState == LetterState.CONNECTED) {
                    return Text('채팅방 이동');
                  } else {
                    return Text('연결하기');
                  }
                },
              ),
            ),
          ),
        ElevatedButton(
          style: AppStyle.getNegativeElevatedButtonStyle(context),
          onPressed: () async {
            try {
              if (letterState == LetterState.SENT && userRole == UserRole.SENDER) {
                await letterProvider.sinkLetter(id: letter.id, userRoleModel: UserRoleModel(id: user.id, userRole: userRole));
                SnackBarUtil.showCustomSnackBar(context, '유리병이 가라앉았습니다.');

              } else if (letterState == LetterState.LOCKED && userRole == UserRole.RECEIVER) {
                await letterProvider.returnLetter(id: letter.id, userRoleModel: UserRoleModel(id: user.id, userRole: userRole));
                SnackBarUtil.showCustomSnackBar(context, '유리병을 바다로 돌려보냈습니다.');

              } else {
                await letterProvider.disconnectLetter(id: letter.id, userRoleModel: UserRoleModel(id: user.id, userRole: userRole));
                SnackBarUtil.showCustomSnackBar(context, '상대방과의 연결을 끊었습니다.');
              }
              Navigator.of(context).pop();

            } catch (e) {
              if (e is DioException && e.response?.statusCode == HttpStatus.notFound) {
                SnackBarUtil.showCustomSnackBar(context, '편지를 찾을 수 없습니다.');
              } else if (e is DioException && e.response?.statusCode == HttpStatus.forbidden) {
                SnackBarUtil.showCustomSnackBar(context, '유효한 사용자가 아닙니다.');
              } else {
                SnackBarUtil.showCommonErrorSnackBar(context);
              }
            }
          },
          child: Builder(
            builder: (context) {
              if (letterState == LetterState.SENT && userRole == UserRole.SENDER) {
                return Text('유리병 가라앉히기');
              } else if (letterState == LetterState.LOCKED && userRole == UserRole.RECEIVER) {
                return Text('돌려놓기');
              } else {
                return Text('연결 끊기');
              }
            },
          ),
        ),
      ],
    );
  }
}

