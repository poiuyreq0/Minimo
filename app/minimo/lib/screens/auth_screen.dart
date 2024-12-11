import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimo/utils/url_util.dart';
import 'package:minimo/models/user_model.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/screens/intro_screen.dart';
import 'package:minimo/screens/splash_screen.dart';
import 'package:minimo/utils/dialog_util.dart';
import 'package:provider/provider.dart';
import 'root_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = context.read<UserProvider>();

    return StreamBuilder<User?>(
      stream: userProvider.userChanges(),
      builder: (context, snapshot) {
        // 로그인 및 이메일 인증 확인
        if (!snapshot.hasData || (snapshot.hasData && !snapshot.data!.emailVerified)) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: SignInScreen(
              actions: [
                AuthStateChangeAction<AuthState>((context, state) async {
                  await handleEmailVerified(context, state, snapshot);
                },),
              ],
              providers: [
                EmailAuthProvider(),
              ],
              headerBuilder: (context, constraints, shrinkOffset) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(UrlUtil.iconClear),
                  ),
                );
              },
              subtitleBuilder: (context, action) {
                return Text('Mini Moment에 오신 것을 환영합니다!');
              },
              showPasswordVisibilityToggle: true,
            ),
          );
        } else {
          return FutureBuilder<UserModel?>(
            future: userProvider.getUserByEmail(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              } else if (!snapshot.hasData) {
                return IntroScreen();
              } else {
                return RootScreen();
              }
            }
          );
        }
      }
    );
  }

  Future<void> handleEmailVerified(
    BuildContext context,
    AuthState state,
    AsyncSnapshot<User?> snapshot,
  ) async {
    if (state is UserCreated) {
      DialogUtil.showCustomDialog(
        context: context,
        title: '회원가입 완료',
        content: '로그인 화면에서 로그인을 완료해 주세요.',
        negativeText: '닫기',
        onNegativePressed: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => AuthScreen(),),
            (route) => false,
          );
        },
      );
    } else if (state is SignedIn) {
      // StreamBuilder FirebaseAuth userChanges() Reload
      await snapshot.data!.reload();

      if (!snapshot.data!.emailVerified) {
        snapshot.data!.sendEmailVerification();
        DialogUtil.showCustomDialog(
          context: context,
          title: '신규 가입자 이메일 인증',
          content: '이메일로 전송된 인증 링크를 클릭하면 계정이 활성화됩니다.',
          positiveText: '재전송',
          onPositivePressed: () async {
            snapshot.data!.sendEmailVerification();
          },
          negativeText: '닫기',
          onNegativePressed: () async {
            Navigator.of(context).pop();
          },
        );
      }
    }
  }
}
