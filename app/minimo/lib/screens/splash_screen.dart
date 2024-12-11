import 'package:flutter/material.dart';
import 'package:minimo/utils/url_util.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          UrlUtil.iconClear,
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
