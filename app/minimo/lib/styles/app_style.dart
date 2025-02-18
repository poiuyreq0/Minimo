import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  final Brightness brightness;

  const AppStyle({
    required this.brightness,
  });

  ColorScheme get mainColorScheme => ColorScheme.fromSeed(
    seedColor: brightness == Brightness.light ? Colors.lightGreen : Colors.black,
    brightness: brightness,
  );

  // TextStyle get mainTextStyle => GoogleFonts.jua();
  TextStyle get mainTextStyle => TextStyle(
    fontFamily: 'KCC-Ganpan',
  );

  TextTheme get mainTextTheme {
    return TextTheme(
      // Firebase UI Auth -> Sign in
      headlineSmall: mainTextStyle.copyWith(
        fontSize: 22,
        color: mainColorScheme.primary,
      ),

      // Firebase UI Auth -> Register, Forgotten password?, Sign in Button
      labelLarge: mainTextStyle.copyWith(
        fontSize: 16,
        color: mainColorScheme.primary,
      ),

      // Firebase UI Auth -> Email, Password
      bodyLarge: mainTextStyle.copyWith(
        fontSize: 16,
        color: mainColorScheme.secondary,
      ),

      // Firebase UI Auth -> Subtitle Text
      bodyMedium: mainTextStyle.copyWith(
        fontSize: 16,
        color: mainColorScheme.secondary,
      ),

      // Firebase UI Auth -> Don’t have an account?
      bodySmall: mainTextStyle.copyWith(
        fontSize: 14,
        color: mainColorScheme.tertiary,
      ),

      // AppBar
      titleMedium: mainTextStyle.copyWith(
        fontSize: 16,
        color: mainColorScheme.secondary,
      ),
    );
  }

  static TextStyle getLargeTextStyle(BuildContext context, [double? fontSize]) {
    return TextStyle(
      fontFamily: 'KCC-Ganpan',
      fontSize: fontSize ?? 18,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  static TextStyle getMediumTextStyle(BuildContext context, [double? fontSize]) {
    return TextStyle(
      fontFamily: 'KCC-Ganpan',
      fontSize: fontSize ?? 16,
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  static TextStyle getSmallTextStyle(BuildContext context, [double? fontSize]) {
    return TextStyle(
      fontFamily: 'KCC-Ganpan',
      fontSize: fontSize ?? 14,
      color: Theme.of(context).colorScheme.tertiary,
    );
  }

  static TextStyle getDividedElementTextStyle(BuildContext context, double fontSize, {bool isTitle = true}) {
    return TextStyle(
      fontFamily: 'KCC-Ganpan',
      fontSize: fontSize,
      color: isTitle ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.tertiary,
    );
  }

  static TextStyle getLittleButtonTextStyle(BuildContext context, {bool isPositive = true}) {
    return TextStyle(
      fontFamily: 'KCC-Ganpan',
      fontSize: 15,
      color: isPositive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.tertiary,
    );
  }

  static TextStyle getHintTextStyle(BuildContext context) {
    return TextStyle(
      fontFamily: 'KCC-Ganpan',
      fontSize: 16,
      color: Theme.of(context).colorScheme.tertiary,
    );
  }

  static TextStyle getInputTextStyle(BuildContext context, {bool isHint = false}) {
    return TextStyle(
      fontFamily: 'KCC-Ganpan',
      fontSize: 16,
      color: Theme.of(context).colorScheme.tertiary,
    );
  }

  AppBarTheme get mainAppBarTheme => AppBarTheme(
    iconTheme: mainIconThemeData,
    titleTextStyle: mainTextTheme.titleMedium,
  );

  IconThemeData get mainIconThemeData => IconThemeData(
    color: mainColorScheme.secondary,
  );

  static BoxDecoration getMainBoxDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.onPrimary,
      border: Border.all(
        color: Theme.of(context).colorScheme.inversePrimary,
        width: 3,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }

  static BoxDecoration getSubBoxDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.onPrimary,
      border: Border.all(
        color: Theme.of(context).colorScheme.secondaryFixedDim,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }

  static InputDecoration getMainInputDecoration({
    required BuildContext context,
    required String label,
    String? hintText,
    String? counterText = '',
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      label: Text(
        label,
        style: AppStyle.getMediumTextStyle(context),
      ),
      hintText: hintText,
      hintStyle: AppStyle.getInputTextStyle(context, isHint: true),
      counterText: counterText,
      contentPadding: const EdgeInsets.only(top: 8),
      suffixIcon: suffixIcon,
    );
  }

  static ButtonStyle getPositiveElevatedButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      textStyle: AppStyle.getMediumTextStyle(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  static ButtonStyle getNegativeElevatedButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      textStyle: AppStyle.getMediumTextStyle(context),
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      foregroundColor: Theme.of(context).colorScheme.onTertiary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}