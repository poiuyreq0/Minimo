import 'package:flutter/material.dart';
import 'package:minimo/components/divided_element_component.dart';
import 'package:minimo/components/divided_little_title_component.dart';
import 'package:minimo/components/images/user_network_image_component.dart';
import 'package:minimo/components/little_title_component.dart';
import 'package:minimo/components/title_component.dart';
import 'package:minimo/enums/gender.dart';
import 'package:minimo/models/user_model.dart';
import 'package:minimo/providers/chat_provider.dart';
import 'package:minimo/providers/letter_provider.dart';
import 'package:minimo/providers/post_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/screens/home/info/info_input_screen.dart';
import 'package:minimo/screens/user_image_screen.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/time_stamp_util.dart';
import 'package:provider/provider.dart';

import '../../auth_screen.dart';
import 'profile_input_screen.dart';
import 'password_input_screen.dart';
import 'user_delete_screen.dart';

class InfoScreen extends StatelessWidget {
  InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('사용자 정보'),
      ),
      body: SingleChildScrollView(
        child: Selector<UserProvider, bool>(
          selector: (context, userProvider) => userProvider.infoScreenSelectorTrigger,
          builder: (context, _, child) {
            UserProvider userProvider = context.read<UserProvider>();
            UserModel user = userProvider.userCache!;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      TitleComponent(
                        title: '내 프로필',
                        buttonText: '변경',
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProfileInputScreen(),
                              )
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Row(
                          children: [
                            Builder(
                              builder: (context) {
                                if (user.isProfileImageSet) {
                                  return UserNetworkImageComponent(
                                    userId: user.id,
                                    size: 60,
                                    cache: false,
                                  );
                                } else {
                                  return UserNetworkImageComponent(
                                    userId: 0,
                                    size: 60,
                                    cache: false,
                                  );
                                }
                              }
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 2,
                              child: Text(
                                user.nickname,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                const Divider(
                  height: 48,
                  indent: 16,
                  endIndent: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TitleComponent(
                        title: '내 정보',
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
                        decoration: AppStyle.getMainBoxDecoration(context),
                        child: Column(
                          children: [
                            DividedElementComponent(
                              title: '이름',
                              content: user.userInfo.name!,
                            ),
                            const SizedBox(height: 12),
                            DividedElementComponent(
                              title: 'MBTI',
                              content: user.userInfo.mbti!.name,
                            ),
                            const SizedBox(height: 12),
                            DividedElementComponent(
                              title: '성별',
                              content: user.userInfo.gender! == Gender.MALE ? '남성' : '여성',
                            ),
                            const SizedBox(height: 12),
                            DividedElementComponent(
                              title: '생일',
                              content: TimeStampUtil.getBirthdayTimeStamp(user.userInfo.birthday!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(
                  height: 48,
                  indent: 16,
                  endIndent: 16,
                ),
                DividedLittleTitleComponent(
                  title: 'Email',
                  content: userProvider.emailCache!,
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
                    await context.read<UserProvider>().logout();
                    context.read<LetterProvider>().logout();
                    context.read<PostProvider>().logout();
                    context.read<ChatProvider>().logout();

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => AuthScreen(),),
                      (route) => false,
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }
}
