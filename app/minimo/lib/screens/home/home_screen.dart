import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:minimo/components/ads/banner_ad_component.dart';
import 'package:minimo/components/images/net_icon_component.dart';
import 'package:minimo/components/little_letter_list_component.dart';
import 'package:minimo/enums/item.dart';
import 'package:minimo/enums/letter_option.dart';
import 'package:minimo/enums/user_role.dart';
import 'package:minimo/models/simple_letter_model.dart';
import 'package:minimo/providers/letter_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/screens/home/letter_box/letter_detail_screen.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/dialog_util.dart';
import 'package:minimo/utils/snack_bar_util.dart';
import 'package:minimo/utils/url_util.dart';
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
    LetterProvider letterProvider = context.read<LetterProvider>();
    final userId = context.read<UserProvider>().userCache!.id;

    return Selector2<LetterProvider, UserProvider, Tuple2<bool, bool>>(
      selector: (context, letterProvider, userProvider) {
        return Tuple2(letterProvider.homeScreenSelectorTrigger, userProvider.homeScreenSelectorTrigger);
      },
      builder: (context, tuple, child) {
        return FutureBuilder<Map<LetterOption, List<SimpleLetterModel>>>(
            future: letterProvider.getSimpleLetters(userId: userId, count: 5),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              } else {
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          BannerAdComponent(
                            padding: 24,
                          ),
                          const SizedBox(height: 8),
                          LittleLetterListComponent(
                            title: '나에게 온 편지',
                            letters: snapshot.data![LetterOption.ALL]!,
                            onPressed: () async {
                              _showReceiveLetterDialog(context, LetterOption.ALL);
                            },
                          ),
                          const SizedBox(height: 8),
                          LittleLetterListComponent(
                            title: '이름으로 온 편지',
                            letters: snapshot.data![LetterOption.NAME]!,
                            onPressed: () async {
                              _showReceiveLetterDialog(context, LetterOption.NAME);
                            },
                          ),
                          const SizedBox(height: 8),
                          LittleLetterListComponent(
                            title: 'MBTI로 온 편지',
                            letters: snapshot.data![LetterOption.MBTI]!,
                            onPressed: () async {
                              _showReceiveLetterDialog(context, LetterOption.MBTI);
                            },
                          ),
                          const SizedBox(height: 8),
                          LittleLetterListComponent(
                            title: '성별로 온 편지',
                            letters: snapshot.data![LetterOption.GENDER]!,
                            onPressed: () async {
                              _showReceiveLetterDialog(context, LetterOption.GENDER);
                            },
                          ),
                          const SizedBox(height: 8),
                          LittleLetterListComponent(
                            title: '어쩌다 온 편지',
                            letters: snapshot.data![LetterOption.NONE]!,
                            onPressed: () async {
                              _showReceiveLetterDialog(context, LetterOption.NONE);
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

  void _showReceiveLetterDialog(BuildContext context, LetterOption letterOption) {
    DialogUtil.showCustomDialog(
      context: context,
      title: '유리병 건지기',
      widgetContent: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(child: NetIconComponent()),
            TextSpan(
              text: '를 하나 소모합니다.',
              style: AppStyle.getMediumTextStyle(context),
            ),
          ],
        ),
      ),
      positiveText: '건지기',
      onPositivePressed: () async {
        final netNum = context.read<UserProvider>().userCache!.netNum;
        if (netNum <= 0) {
          Navigator.of(context).pop();
          SnackBarUtil.showCustomWidgetSnackBar(
            context: context,
            content: Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(child: NetIconComponent()),
                  TextSpan(
                    text: '가 부족합니다.',
                  ),
                ],
              ),
            ),
          );
        } else {
          try {
            LetterProvider letterProvider = context.read<LetterProvider>();
            UserProvider userProvider = context.read<UserProvider>();
            final userId = userProvider.userCache!.id;

            final letter = await letterProvider.receiveLetter(receiverId: userId, letterOption: letterOption);
            await userProvider.getItemNum(item: Item.NET);

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => LetterDetailScreen(letter: letter, userRole: UserRole.RECEIVER),
              ),
              (route) => route.isFirst,
            );
            SnackBarUtil.showCustomSnackBar(context, '건지기에 성공했습니다!');

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
      onNegativePressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
