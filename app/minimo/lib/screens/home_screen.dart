import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:minimo/components/heart_icon_component.dart';
import 'package:minimo/components/little_letter_list_component.dart';
import 'package:minimo/consts/gender.dart';
import 'package:minimo/consts/letter_option.dart';
import 'package:minimo/consts/letter_state.dart';
import 'package:minimo/consts/mbti.dart';
import 'package:minimo/consts/user_role.dart';
import 'package:minimo/models/letter_content_model.dart';
import 'package:minimo/models/letter_element_model.dart';
import 'package:minimo/models/letter_model.dart';
import 'package:minimo/models/user_info_model.dart';
import 'package:minimo/models/user_model.dart';
import 'package:minimo/providers/letter_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/screens/letter_detail_screen.dart';
import 'package:provider/provider.dart';

import 'splash_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, LetterProvider>(
      builder: (context, userProvider, letterProvider, child) {
        return FutureBuilder<Map<LetterOption, List<LetterElementModel>>>(
            future: letterProvider.getLettersByEveryOption(userId: userProvider.userCache!.id, count: 5),
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
                          LittleLetterListComponent(
                            title: '짝사랑에게 온 편지',
                            letters: snapshot.data![LetterOption.ALL]!,
                            onPressed: () async {
                              showReceiveLetterDialog(LetterOption.ALL, userProvider, letterProvider);
                            },
                          ),
                          const SizedBox(height: 8,),
                          LittleLetterListComponent(
                            title: '이름으로 온 편지',
                            letters: snapshot.data![LetterOption.NAME]!,
                            onPressed: () async {
                              showReceiveLetterDialog(LetterOption.NAME, userProvider, letterProvider);
                            },
                          ),
                          const SizedBox(height: 8,),
                          LittleLetterListComponent(
                            title: 'MBTI로 온 편지',
                            letters: snapshot.data![LetterOption.MBTI]!,
                            onPressed: () async {
                              showReceiveLetterDialog(LetterOption.MBTI, userProvider, letterProvider);
                            },
                          ),
                          const SizedBox(height: 8,),
                          LittleLetterListComponent(
                            title: '성별로 온 편지',
                            letters: snapshot.data![LetterOption.GENDER]!,
                            onPressed: () async {
                              showReceiveLetterDialog(LetterOption.GENDER, userProvider, letterProvider);
                            },
                          ),
                          const SizedBox(height: 8,),
                          LittleLetterListComponent(
                            title: '어쩌다 온 편지',
                            letters: snapshot.data![LetterOption.NONE]!,
                            onPressed: () async {
                              showReceiveLetterDialog(LetterOption.NONE, userProvider, letterProvider);
                            },
                          ),
                          const SizedBox(height: 64,),
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            '유리병 건지기',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Row(
            children: [
              HeartIconComponent(),
              Text(
                '를 하나 소모하여 유리병을 건집니다.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (userProvider.userCache!.heartNum <= 0) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            HeartIconComponent(),
                            Text('가 부족합니다.'),
                          ],
                        ),
                      )
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
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('건지기에 성공했습니다!\n유리병 편지는 편지함에서 확인할 수 있습니다.'),
                        )
                    );

                  } on DioException catch (e) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('아직 나에게 온 유리병이 없습니다.'),
                        )
                    );
                  }
                }
              },
              child: Text(
                '건지기',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: Text(
                '닫기',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        );
      },
    );
  }
}
