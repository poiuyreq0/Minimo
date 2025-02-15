import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:minimo/localizations/firebase_ui_localization.dart';
import 'package:minimo/providers/chat_provider.dart';
import 'package:minimo/providers/letter_provider.dart';
import 'package:minimo/providers/post_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/repositories/chat_repository.dart';
import 'package:minimo/repositories/letter_repository.dart';
import 'package:minimo/repositories/post_repository.dart';
import 'package:minimo/repositories/user_repository.dart';
import 'package:minimo/screens/auth_screen.dart';
import 'package:minimo/styles/app_theme.dart';
import 'package:minimo/utils/navigator_util.dart';
import 'package:provider/provider.dart';

import 'utils/notification_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Google AdMob 초기화
  unawaited(MobileAds.instance.initialize());

  // Firebase 초기화
  await Firebase.initializeApp();

  // FCM, Flutter Local Notifications 초기화
  NotificationUtil.initializeNotification(NavigatorUtil.navigatorKey);

  runMinimoApp();
}

void runMinimoApp() {
  debugPrint('main runMinimoApp start: ');

  final userRepository = UserRepository();
  final userProvider = UserProvider(userRepository: userRepository);
  final letterRepository = LetterRepository();
  final letterProvider = LetterProvider(letterRepository: letterRepository);
  final postRepository = PostRepository();
  final postProvider = PostProvider(postRepository: postRepository);
  final chatRepository = ChatRepository();
  final chatProvider = ChatProvider(chatRepository: chatRepository);

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => userProvider),
          ChangeNotifierProvider(create: (context) => letterProvider),
          ChangeNotifierProvider(create: (context) => postProvider),
          ChangeNotifierProvider(create: (context) => chatProvider),
        ],
        child: MaterialApp(
          navigatorKey: NavigatorUtil.navigatorKey,
          debugShowCheckedModeBanner: false,
          locale: const Locale('ko', 'KR'),
          supportedLocales: const [
            Locale('ko', 'KR'),
            Locale('en', 'US'),
          ],
          localizationsDelegates: [
            FirebaseUILocalizations.withDefaultOverrides(const FirebaseUILocalization()),
            FirebaseUILocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.getMainThemeData(Brightness.light),
          darkTheme: AppTheme.getMainThemeData(Brightness.dark),
          themeMode: ThemeMode.system,
          home: AuthScreen(),
        ),
      )
  );
}


