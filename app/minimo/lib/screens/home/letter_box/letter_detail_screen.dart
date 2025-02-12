import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:minimo/components/images/user_network_image_component.dart';
import 'package:minimo/enums/letter_state.dart';
import 'package:minimo/enums/report_reason.dart';
import 'package:minimo/enums/user_role.dart';
import 'package:minimo/models/letter_model.dart';
import 'package:minimo/models/user_model.dart';
import 'package:minimo/providers/chat_provider.dart';
import 'package:minimo/providers/letter_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/screens/chat/chat_room_screen.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/dialog_util.dart';
import 'package:minimo/utils/notification_util.dart';
import 'package:minimo/utils/snack_bar_util.dart';
import 'package:minimo/utils/time_stamp_util.dart';
import 'package:provider/provider.dart';

class LetterDetailScreen extends StatefulWidget {
  final LetterModel letter;
  final UserRole userRole;

  const LetterDetailScreen({
    required this.letter,
    required this.userRole,
    super.key
  });

  @override
  State<LetterDetailScreen> createState() => _LetterDetailScreenState();
}

class _LetterDetailScreenState extends State<LetterDetailScreen> {
  @override
  void initState() {
    super.initState();
    NotificationUtil.cancelNotification(widget.letter.id, 'letter');
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserProvider>().userCache!.id;

    return Scaffold(
      appBar: AppBar(
        title: Text('유리병 편지'),
        actions: [
          if (widget.letter.senderId != null && widget.letter.senderId != userId)
            PopupMenuButton<String>(
              padding: const EdgeInsets.all(16),
              onSelected: (value) async {
                if (value == '신고') {
                  late final ReportReason reportReason;

                  await showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Text('신고 사유'),
                        children: ReportReason.values.map<SimpleDialogOption>(
                              (value) => SimpleDialogOption(
                            child: Text(value.description),
                            onPressed: () {
                              reportReason = value;
                              Navigator.of(context).pop();
                            },
                          ),
                        ).toList(),
                      );
                    },
                  );

                  await DialogUtil.showCustomDialog(
                    context: context,
                    title: reportReason.description,
                    content: '${widget.letter.senderNickname} 님을 신고하시겠습니까?\n',
                    positiveText: '신고',
                    onPositivePressed: () async {
                      UserProvider userProvider = context.read<UserProvider>();

                      try {
                        await userProvider.reportUser(targetId: widget.letter.senderId!, reportReason: reportReason);

                        Navigator.of(context).pop();
                        SnackBarUtil.showCustomSnackBar(context, '신고가 등록되었습니다.');

                      } catch (e) {
                        Navigator.of(context).pop();
                        if (e is DioException && e.response?.statusCode == HttpStatus.conflict) {
                          SnackBarUtil.showCustomSnackBar(context, '해당 신고는 이미 접수되었습니다.');
                        } else {
                          SnackBarUtil.showCommonErrorSnackBar(context);
                        }
                      }
                    },
                    negativeText: '취소',
                    onNegativePressed: () {
                      Navigator.of(context).pop();
                    },
                  );

                } else if (value == '차단') {
                  DialogUtil.showCustomDialog(
                    context: context,
                    title: '사용자 차단',
                    content: '${widget.letter.senderNickname} 님을 차단하시겠습니까?',
                    positiveText: '차단',
                    onPositivePressed: () async {
                      UserProvider userProvider = context.read<UserProvider>();

                      try {
                        await userProvider.banUser(targetId: widget.letter.senderId!, targetNickname: widget.letter.senderNickname!);
                        Navigator.of(context).popUntil(
                              (route) => route.isFirst,
                        );

                      } catch (e) {
                        Navigator.of(context).pop();
                        SnackBarUtil.showCommonErrorSnackBar(context);
                      }
                    },
                    negativeText: '취소',
                    onNegativePressed: () {
                      Navigator.of(context).pop();
                    },
                  );
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem<String>(
                    value: '신고',
                    child: Text(
                      '신고',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: '차단',
                    child: Text(
                      '차단',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ];
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24.0),
                alignment: Alignment.center,
                decoration: AppStyle.getMainBoxDecoration(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          'To. ${widget.letter.receiverNickname ?? '(알 수 없음)'}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 8),
                        UserNetworkImageComponent(
                          userId: widget.letter.receiverId,
                          cache: false,
                          size: 36,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      widget.letter.letterContent.title,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.letter.letterContent.content,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'From. ${widget.letter.senderNickname ?? '(알 수 없음)'}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 8),
                        UserNetworkImageComponent(
                          userId: widget.letter.senderId,
                          cache: false,
                          size: 36,
                        ),
                      ],
                    ),
                    const Divider(
                      height: 36,
                    ),
                    if (widget.letter.createdDate != null)
                      Text(
                        '발신일: ${TimeStampUtil.getDetailTimeStamp(widget.letter.createdDate!)}',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    if (widget.letter.receivedDate != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            '수신일: ${TimeStampUtil.getDetailTimeStamp(widget.letter.receivedDate!)}',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    if (widget.letter.connectedDate != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            '연결일: ${TimeStampUtil.getDetailTimeStamp(widget.letter.connectedDate!)}',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _actionButton(
                context: context,
                letter: widget.letter,
                letterState: widget.letter.letterState!,
                userRole: widget.userRole,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required BuildContext context,
    required LetterModel letter,
    required LetterState letterState,
    required UserRole userRole,
  }) {
    LetterProvider letterProvider = context.read<LetterProvider>();
    final userId = context.read<UserProvider>().userCache!.id;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: AppStyle.getNegativeElevatedButtonStyle(context),
          onPressed: () async {
            try {
              if (letterState == LetterState.SENT && userRole == UserRole.SENDER) {
                await letterProvider.sinkLetter(letterId: letter.id, userId: userId, userRole: userRole);
                SnackBarUtil.showCustomSnackBar(context, '유리병이 가라앉았습니다.');

              } else if (letterState == LetterState.RECEIVED && userRole == UserRole.RECEIVER) {
                await letterProvider.returnLetter(letterId: letter.id, userId: userId, userRole: userRole);
                SnackBarUtil.showCustomSnackBar(context, '유리병을 바다로 돌려보냈습니다.');

              } else if (letterState == LetterState.RECEIVED && userRole == UserRole.SENDER) {
                await letterProvider.disconnectLetter(letterId: letter.id, userId: userId, userRole: userRole);
                SnackBarUtil.showCustomSnackBar(context, '유리병 편지와의 연결을 끊었습니다.');

              } else {
                await DialogUtil.showCustomDialog(
                  context: context,
                  title: '연결 끊기',
                  content: '편지의 연결을 끊으면 채팅방도 함께 나가집니다.\n정말 연결을 끊으시겠습니까?',
                  positiveText: '끊기',
                  onPositivePressed: () async {
                    await letterProvider.disconnectLetter(letterId: letter.id, userId: userId, userRole: userRole);
                    Navigator.of(context).pop();
                    SnackBarUtil.showCustomSnackBar(context, '유리병 편지와의 연결을 끊었습니다.');
                  },
                  negativeText: '취소',
                  onNegativePressed: () {
                    Navigator.of(context).pop();
                  },
                );
              }
              Navigator.of(context).pop();

            } catch (e) {
              if (e is DioException && e.response?.statusCode == HttpStatus.notFound) {
                SnackBarUtil.showCustomSnackBar(context, '편지를 찾을 수 없습니다.');
              } else {
                SnackBarUtil.showCommonErrorSnackBar(context);
              }
            }
          },
          child: Builder(
            builder: (context) {
              if (letterState == LetterState.SENT && userRole == UserRole.SENDER) {
                return Text('유리병 가라앉히기');
              } else if (letterState == LetterState.RECEIVED && userRole == UserRole.RECEIVER) {
                return Text('돌려놓기');
              } else {
                return Text('연결 끊기');
              }
            },
          ),
        ),
        if (letterState == LetterState.CONNECTED || letterState == LetterState.RECEIVED && userRole == UserRole.RECEIVER)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              style: AppStyle.getPositiveElevatedButtonStyle(context),
              onPressed: () async {
                int? chatRoomId = letter.chatRoomId;

                // 편지 연결
                if (letterState != LetterState.CONNECTED) {
                  try {
                    chatRoomId = await letterProvider.connectLetter(letterId: letter.id, userId: userId, userRole: userRole);

                    Navigator.of(context).pop();
                    SnackBarUtil.showCustomSnackBar(context, '연결에 성공했습니다!\n상대방과 대화를 시작해 보세요.');

                  } catch (e) {
                    if (e is DioException && e.response?.statusCode == HttpStatus.notFound) {
                      SnackBarUtil.showCustomSnackBar(context, '연결이 끊긴 상대방입니다.\n편지를 연결할 수 없습니다.');
                    } else {
                      SnackBarUtil.showCommonErrorSnackBar(context);
                    }

                    // 연결 실패 시 종료
                    return ;
                  }
                }

                // 채팅방 이동
                try {
                  final otherUserId = userRole != UserRole.SENDER ? letter.senderId : letter.receiverId;
                  final otherUserNickname = userRole != UserRole.SENDER ? letter.senderNickname : letter.receiverNickname;

                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ChatRoomScreen(roomId: chatRoomId!, userId: userId, otherUserId: otherUserId, otherUserNickname: otherUserNickname ?? '(알 수 없음)',),)
                  );

                } catch (e) {
                  if (e is DioException && e.response?.statusCode == HttpStatus.notFound) {
                    SnackBarUtil.showCustomSnackBar(context, '이미 나간 채팅방입니다.');
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
      ],
    );
  }
}
