import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimo/components/divided_element_component.dart';
import 'package:minimo/components/divided_little_title_component.dart';
import 'package:minimo/components/little_title_component.dart';
import 'package:minimo/components/title_component.dart';
import 'package:minimo/providers/letter_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/screens/info_input_screen.dart';
import 'package:minimo/screens/password_input_screen.dart';
import 'package:minimo/screens/user_delete_screen.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:provider/provider.dart';

import 'auth_screen.dart';
import 'nickname_input_screen.dart';

class InfoScreen extends StatelessWidget {
  InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TitleComponent(
                        title: '수신 정보',
                        buttonText: '변경',
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => InfoInputScreen(),
                              )
                          );
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.center,
                        decoration: AppStyle.getMainBoxDecoration(Theme.of(context).colorScheme.onPrimary),
                        child: Column(
                          children: [
                            DividedElementComponent(
                              title: '이름',
                              content: userProvider.userCache!.userInfo.name,
                            ),
                            const SizedBox(height: 8,),
                            DividedElementComponent(
                              title: 'MBTI',
                              content: userProvider.userCache!.userInfo.mbti!.name,
                            ),
                            const SizedBox(height: 8,),
                            DividedElementComponent(
                              title: '성별',
                              content: userProvider.userCache!.userInfo.gender!.name,
                            ),
                            const SizedBox(height: 8,),
                            DividedElementComponent(
                              title: '생일',
                              content: DateFormat('yyyy-MM-dd').format(userProvider.userCache!.userInfo.birthday!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16,),
                const Divider(
                  height: 48,
                  indent: 16,
                  endIndent: 16,
                ),
                DividedLittleTitleComponent(
                  title: 'Email',
                  content: userProvider.emailCache,
                ),
                DividedLittleTitleComponent(
                  title: '닉네임 변경',
                  content: userProvider.userCache!.nickname,
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NicknameInputScreen(),
                        )
                    );
                  },
                ),
                LittleTitleComponent(
                  title: '비밀번호 변경',
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PasswordInputScreen(),
                        )
                    );
                  },
                ),
                const Divider(
                  height: 48,
                  indent: 16,
                  endIndent: 16,
                ),
                LittleTitleComponent(
                  title: '회원 탈퇴',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => UserDeleteScreen(),)
                    );
                  },
                ),
                LittleTitleComponent(
                  title: '로그아웃',
                  onPressed: () async {
                    await userProvider.logout();
                    context.read<LetterProvider>().logout();

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => AuthScreen(),),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}