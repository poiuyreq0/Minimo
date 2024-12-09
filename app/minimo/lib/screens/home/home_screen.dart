import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:minimo/components/heart_icon_component.dart';
import 'package:minimo/components/little_letter_list_component.dart';
import 'package:minimo/consts/letter_option.dart';
import 'package:minimo/consts/user_role.dart';
import 'package:minimo/models/letter_element_model.dart';
import 'package:minimo/models/user_info_model.dart';
import 'package:minimo/models/user_model.dart';
import 'package:minimo/providers/letter_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/screens/home/letter_box/letter_detail_screen.dart';
import 'package:minimo/utils/dialog_util.dart';
import 'package:minimo/utils/snack_bar_util.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../splash_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Selector<UserProvider, Tuple2<UserInfoModel, int>>(
      selector: (context, userProvider) {
        UserModel user = userProvider.userCache!;
        return Tuple2(user.userInfo, user.heartNum);
      },
      builder: (context, tuple, child) {
        UserProvider userProvider = context.read<UserProvider>();
        LetterProvider letterProvider = context.read<LetterProvider>();

        return FutureBuilder<Map<LetterOption, List<LetterElementModel>>>(
            future: letterProvider.getEveryNewLetters(userId: userProvider.userCache!.id, count: 5),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SplashScreen();
              } else {
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          LittleLetterListComponent(
                            title: '짝사랑에게 온 편지',
                            letters: snapshot.data![LetterOption.ALL]!,
                            onPressed: () async {
                              showReceiveLetterDialog(LetterOption.ALL, userProvider, letterProvider);
                            },
                          ),
                          const SizedBox(height: 8),
                          LittleLetterListComponent(
                            title: '이름으로 온 편지',
                            letters: snapshot.data![LetterOption.NAME]!,
                            onPressed: () async {
                              showReceiveLetterDialog(LetterOption.NAME, userProvider, letterProvider);
                            },
                          ),
                          const SizedBox(height: 8),
                          LittleLetterListComponent(
                            title: 'MBTI로 온 편지',
                            letters: snapshot.data![LetterOption.MBTI]!,
                            onPressed: () async {
                              showReceiveLetterDialog(LetterOption.MBTI, userProvider, letterProvider);
                            },
                          ),
                          const SizedBox(height: 8),
                          LittleLetterListComponent(
                            title: '성별로 온 편지',
                            letters: snapshot.data![LetterOption.GENDER]!,
                            onPressed: () async {
                              showReceiveLetterDialog(LetterOption.GENDER, userProvider, letterProvider);
                            },
                          ),
                          const SizedBox(height: 8),
                          LittleLetterListComponent(
                            title: '어쩌다 온 편지',
                            letters: snapshot.data![LetterOption.NONE]!,
                            onPressed: () async {
                              showReceiveLetterDialog(LetterOption.NONE, userProvider, letterProvider);
                            },
                          ),
                          const SizedBox(height: 64),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }
        );
      },
    );
  }

  void showReceiveLetterDialog(LetterOption letterOption, UserProvider userProvider, LetterProvider letterProvider) {
    DialogUtil.showCustomDialog(
      context: context,
      title: '유리병 건지기',
      widgetContent: Row(
        children: [
          HeartIconComponent(),
          Text(
            '를 하나 소모하여 유리병을 건집니다.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
      positiveText: '건지기',
      onPositivePressed: () async {
        if (userProvider.userCache!.heartNum <= 0) {
          Navigator.of(context).pop();
          SnackBarUtil.showCustomWidgetSnackBar(
            context: context,
            content: Row(
              children: [
                HeartIconComponent(),
                Text('가 부족합니다.'),
              ],
            ),
          );

        } else {
          try {
            final letter = await letterProvider.receiveLetter(receiverId: userProvider.userCache!.id, letterOption: letterOption);
            await userProvider.getHeartNum();

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => LetterDetailScreen(letter: letter, userRole: UserRole.RECEIVER),
              ),
                  (route) => route.isFirst,
            );
            SnackBarUtil.showCustomSnackBar(context, '건지기에 성공했습니다!\n유리병 편지는 편지함에서 확인할 수 있습니다.');

          } catch (e) {
            Navigator.of(context).pop();
            if (e is DioException && e.response?.statusCode == HttpStatus.notFound) {
              SnackBarUtil.showCustomSnackBar(context, '아직 나에게 온 유리병이 없습니다.');
            } else {
              SnackBarUtil.showCommonErrorSnackBar(context);
            }
          }
        }
      },
      negativeText: '닫기',
      onNegativePressed: () async {
        Navigator.of(context).pop();
      },
    );
  }
}
