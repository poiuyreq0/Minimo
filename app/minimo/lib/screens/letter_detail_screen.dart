import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimo/consts/letter_state.dart';
import 'package:minimo/consts/user_role.dart';
import 'package:minimo/models/letter_model.dart';
import 'package:minimo/models/user_role_model.dart';
import 'package:minimo/providers/letter_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/styles/app_style.dart';
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
                decoration: AppStyle.getMainBoxDecoration(Theme.of(context).colorScheme.onPrimary),
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
                      const SizedBox(height: 8,),
                      Text(
                        letter.letterContent.content,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Divider(
                        height: 24,
                      ),
                      Text(
                        '보낸 사람   ${letter.senderNickname ?? 'Unknown'}\n받은 사람   ${letter.receiverNickname ?? 'Unknown'}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8,),
                      if (letter.createdDate != null)
                        Text(
                          '보낸 일시   ${DateFormat('yyyy-MM-dd HH:mm:ss').format(letter.createdDate!)}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      if (letter.receivedDate != null)
                        Text(
                          '받은 일시   ${DateFormat('yyyy-MM-dd HH:mm:ss').format(letter.receivedDate!)}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      if (letter.connectedDate != null)
                        Text(
                          '연결 일시   ${DateFormat('yyyy-MM-dd HH:mm:ss').format(letter.connectedDate!)}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16,),
              ActionButton(letter: letter, letterState: letter.letterState!, userRole: userRole,),
              const SizedBox(height: 32,),
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
    int userId = context.read<UserProvider>().userCache!.id;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (letterState == LetterState.CONNECTED || letterState == LetterState.LOCKED && userRole == UserRole.RECEIVER)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () async {
                if (letterState == LetterState.CONNECTED && userRole == UserRole.SENDER) {


                } else if (letterState == LetterState.CONNECTED && userRole == UserRole.RECEIVER) {


                } else {
                  await letterProvider.connectLetter(id: letter.id, userRoleModel: UserRoleModel(id: userId, userRole: userRole));
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('연결에 성공했습니다!\n상대방과 대화를 시작해 보세요.'),
                      )
                  );
                }

                // 채팅방 이동
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            foregroundColor: Theme.of(context).colorScheme.onTertiary,
          ),
          onPressed: () async {
            if (letterState == LetterState.SENT && userRole == UserRole.SENDER) {
              await letterProvider.sinkLetter(id: letter.id, userRoleModel: UserRoleModel(id: userId, userRole: userRole));
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('유리병이 가라앉았습니다.'),
                  )
              );

            } else if (letterState == LetterState.LOCKED && userRole == UserRole.RECEIVER) {
              await letterProvider.returnLetter(id: letter.id, userRoleModel: UserRoleModel(id: userId, userRole: userRole));
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('유리병을 다시 바다로 보냈습니다.'),
                  )
              );

            } else {
              await letterProvider.disconnectLetter(id: letter.id, userRoleModel: UserRoleModel(id: userId, userRole: userRole));
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('상대방과의 연결을 끊었습니다.'),
                  )
              );
            }
            Navigator.of(context).pop();
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

