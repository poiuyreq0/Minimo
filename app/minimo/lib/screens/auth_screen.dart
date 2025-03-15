import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimo/utils/navigator_util.dart';
import 'package:minimo/utils/notification_util.dart';
import 'package:minimo/utils/url_util.dart';
import 'package:minimo/models/user_model.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/screens/intro_screen.dart';
import 'package:minimo/screens/splash_screen.dart';
import 'package:minimo/utils/dialog_util.dart';
import 'package:provider/provider.dart';
import 'root_screen.dart';

class AuthScreen extends StatefulWidget {
  final Map<String, dynamic>? data;

  const AuthScreen({
    this.data,
    super.key
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    debugPrint('AuthScreen initState start: ');
    super.initState();
    NotificationUtil.fcmForegroundHandler(NavigatorUtil.navigatorKey);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('AuthScreen build start: ');
    UserProvider userProvider = context.read<UserProvider>();

    return StreamBuilder<User?>(
      stream: userProvider.userChanges(),
      builder: (context, snapshot) {
        // 로그인 및 이메일 인증 확인
        if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError) {
          debugPrint('AuthScreen StreamBuilder SplashScreen: ${snapshot.error}');
          return SplashScreen();

        } else if (!snapshot.hasData || (snapshot.hasData && !snapshot.data!.emailVerified)) {
          debugPrint('AuthScreen SignInScreen start: ${snapshot.data}');

          return SignInScreen(
            actions: [
              AuthStateChangeAction<AuthState>((context, state) async {
                await _handleError(context, state);
                await _handleEmailVerified(context, state, snapshot);
              },),
            ],
            providers: [
              EmailAuthProvider(),
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.only(top: 36),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(UrlUtil.iconClear),
                ),
              );
            },
            subtitleBuilder: (context, action) {
              return Text('미니모에 오신 것을 환영합니다 :)');
            },
            showPasswordVisibilityToggle: true,
          );

        } else {
          debugPrint('AuthScreen FutureBuilder start: ${snapshot.data}');

          return FutureBuilder<UserModel?>(
            future: userProvider.getUserByEmail(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError) {
                debugPrint('AuthScreen FutureBuilder SplashScreen: ${snapshot.error}');
                return SplashScreen();
              } else if (!snapshot.hasData) {
                return IntroScreen();
              } else {
                return RootScreen(
                  data: widget.data,
                );
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
      DialogUtil.showCustomDialog(
        context: context,
        title: '회원가입 완료',
        content: '미니모 가입을 환영합니다 :)\n로그인 화면으로 이동합니다.',
        negativeText: '닫기',
        onNegativePressed: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => AuthScreen(),),
            (route) => false,
          );
        },
      );

    } else if (state is SignedIn && snapshot.hasData) {
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
          onNegativePressed: () {
            Navigator.of(context).pop();
          },
        );
      }
    }
  }

  Future<void> _handleError(
    BuildContext context,
    AuthState state,
  ) async {
    ErrorText.localizeError = (context, e) {
      return switch (e.code) {
        'invalid-credential' => '아이디 또는 비밀번호가 맞지 않습니다.',
        'email-already-in-use' => '이미 사용 중인 이메일입니다.',
        'unknown' => '비밀번호는 영문 소문자와 숫자를 포함하여 최소 8자 이상이어야 합니다.',
        _ => '요청 처리 중 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요.',
      };
    };
  }
}
