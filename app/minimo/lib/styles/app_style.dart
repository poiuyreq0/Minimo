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

  TextStyle get mainTextStyle => GoogleFonts.jua();

  TextTheme get mainTextTheme {
    return GoogleFonts.juaTextTheme().copyWith(
      // Firebase UI Auth -> Sign in
      headlineSmall: mainTextStyle.copyWith(
        fontSize: 24,
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

      // TitleComponent title
      titleLarge: mainTextStyle.copyWith(
        fontSize: 20,
        color: mainColorScheme.primary,
      ),

      // AppBar title
      // DividedElementComponent title
      // TextFormComponent label
      // DropdownFormComponent label
      titleMedium: mainTextStyle.copyWith(
        fontSize: 16,
        color: mainColorScheme.secondary,
      ),

      // AlertDialog
      // TitleComponent buttonText
      // DividedElementComponent content
      // TextFormComponent content // 16
      // DropdownFormComponent content // 16
      titleSmall: mainTextStyle.copyWith(
        fontSize: 14,
        color: mainColorScheme.tertiary,
      ),

      // List Screen
      displayLarge: mainTextStyle.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: mainColorScheme.primary,
      ),
      displayMedium: mainTextStyle.copyWith(
        fontSize: 14,
        color: mainColorScheme.secondary,
      ),
      displaySmall: mainTextStyle.copyWith(
        fontSize: 12,
        color: mainColorScheme.tertiary,
      ),
    );
  }

  TextStyle get handwritingTextStyle => GoogleFonts.nanumPenScript(
    fontSize: 18,
  );

  AppBarTheme get mainAppBarTheme => AppBarTheme(
    iconTheme: mainIconThemeData,
    titleTextStyle: mainTextTheme.titleMedium,
  );

  IconThemeData get mainIconThemeData => IconThemeData(
    color: mainColorScheme.secondary,
  );

  static BoxDecoration getMainBoxDecoration(BuildContext context) => BoxDecoration(
    color: Theme.of(context).colorScheme.onPrimary,
    border: Border.all(
      color: Theme.of(context).colorScheme.inversePrimary,
      width: 3,
    ),
    borderRadius: BorderRadius.circular(10),
    // boxShadow: [
    //   BoxShadow(
    //     color: Theme.of(context).colorScheme.shadow,
    //     blurRadius: 0,
    //     blurStyle: BlurStyle.outer,
    //   ),
    // ],
  );
}