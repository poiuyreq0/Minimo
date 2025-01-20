import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_style.dart';

class AppTheme {
  static ThemeData getMainThemeData(Brightness brightness) {
    AppStyle appStyle = AppStyle(brightness: brightness);

    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: appStyle.mainTextStyle.fontFamily,
      textTheme: appStyle.mainTextTheme,
      colorScheme: appStyle.mainColorScheme,
      appBarTheme: appStyle.mainAppBarTheme,
      iconTheme: appStyle.mainIconThemeData,
      useMaterial3: true,
    );
  }
}