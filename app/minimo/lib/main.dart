import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:minimo/localizations/firebase_ui_localization.dart';
import 'package:minimo/providers/letter_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/repositories/letter_repository.dart';
import 'package:minimo/repositories/user_repository.dart';
import 'package:minimo/screens/auth_screen.dart';
import 'package:minimo/styles/app_theme.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  // Flutter 프레임워크가 완전히 부팅되기까지 대기
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp(
    // 실행 중인 플랫폼 감지
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final userRepository = UserRepository();
  final userProvider = UserProvider(userRepository: userRepository);
  final letterRepository = LetterRepository();
  final letterProvider = LetterProvider(letterRepository: letterRepository);

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => letterProvider),
          ChangeNotifierProvider(create: (_) => userProvider),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: const Locale('ko', 'KR'),
          localizationsDelegates: [
            FirebaseUILocalizations.withDefaultOverrides(const FirebaseUILocalization()),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            FirebaseUILocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ko', 'KR'),
            Locale('en', 'US'),
          ],
          theme: AppTheme.getMainThemeData(Brightness.light),
          darkTheme: AppTheme.getMainThemeData(Brightness.dark),
          themeMode: ThemeMode.system,
          home: AuthScreen(),
        ),
      )
  );
}