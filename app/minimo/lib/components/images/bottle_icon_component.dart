import 'package:flutter/material.dart';
import 'package:minimo/utils/url_util.dart';

class BottleIconComponent extends StatelessWidget {
  final double size;

  const BottleIconComponent({
    this.size = 20,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      UrlUtil.iconBottle,
      width: size,
      height: size,
    );
  }
}
