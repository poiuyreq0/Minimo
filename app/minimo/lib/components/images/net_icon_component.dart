import 'package:flutter/material.dart';
import 'package:minimo/utils/url_util.dart';

class NetIconComponent extends StatelessWidget {
  final double size;

  const NetIconComponent({
    this.size = 20,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      UrlUtil.iconNet,
      width: size,
      height: size,
    );
  }
}
