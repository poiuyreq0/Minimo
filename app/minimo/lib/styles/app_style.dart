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
    // return GoogleFonts.juaTextTheme().copyWith(
    return TextTheme(

      // Firebase UI Auth -> Sign in
      headlineSmall: mainTextStyle.copyWith(
        fontSize: 22,
        color: mainColorScheme.primary,
      ),

      // Firebase UI Auth -> Register, Forgotten password?, Sign in Button
      labelLarge: mainTextStyle.copyWith(
        fontSize: 18,
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
        fontSize: 18,
        color: mainColorScheme.primary,
      ),

      // AppBar
      // AlertDialog
      // DividedElementComponent title
      // TextFormComponent label
      // DropdownFormComponent label
      titleMedium: mainTextStyle.copyWith(
        fontSize: 16,
        color: mainColorScheme.secondary,
      ),

      // TitleComponent buttonText
      // DividedElementComponent content
      // TextFormComponent content
      // DropdownFormComponent content
      titleSmall: mainTextStyle.copyWith(
        fontSize: 15,
        color: mainColorScheme.tertiary,
      ),

      // List Screen
      displayLarge: mainTextStyle.copyWith(
        fontSize: 16,
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
        style: Theme.of(context).textTheme.titleMedium,
      ),
      hintText: hintText,
      hintStyle: Theme.of(context).textTheme.titleSmall,
      counterText: counterText,
      contentPadding: const EdgeInsets.only(top: 8),
      suffixIcon: suffixIcon,
    );
  }

  static ButtonStyle getPositiveElevatedButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  static ButtonStyle getNegativeElevatedButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      foregroundColor: Theme.of(context).colorScheme.onTertiary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}