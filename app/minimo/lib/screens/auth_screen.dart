import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimo/models/user_model.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/screens/intro_screen.dart';
import 'package:minimo/screens/splash_screen.dart';
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
        // if (!snapshot.hasData || (snapshot.hasData && !snapshot.data!.emailVerified)) {
        debugPrint('snapshot data : ${snapshot.data}');
        if (!snapshot.hasData) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: SignInScreen(
              providers: [
                EmailAuthProvider(),
              ],
              // actions: [
              //   AuthStateChangeAction<AuthState>((context, state) async {
              //     await _handleEmailVerified(context, state, snapshot);
              //   },),
              // ],
              headerBuilder: (context, constraints, shrinkOffset) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset('assets/icons/icon_clear.png'),
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

  Future<void> _handleEmailVerified(
    BuildContext context,
    AuthState state,
    AsyncSnapshot<User?> snapshot,
  ) async {
    if (state is UserCreated) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              '회원가입 완료',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: Text(
              '로그인 화면에서 로그인을 완료해 주세요.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AuthScreen(),),
                    (route) => false,
                  );
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
    } else if (state is SignedIn) {
      await snapshot.data!.reload();
      if (!snapshot.data!.emailVerified && context.mounted) {
        snapshot.data!.sendEmailVerification();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                '신규 가입자 계정 인증',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              content: Text(
                '이메일로 전송된 인증 링크를 클릭하여 계정을 활성화해 주세요.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await snapshot.data!.reload();
                    snapshot.data!.sendEmailVerification();
                  },
                  child: Text(
                    '재전송',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await snapshot.data!.reload();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
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
  }
}
