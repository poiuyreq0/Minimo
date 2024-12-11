import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:minimo/utils/url_util.dart';

class UserFileImageComponent extends StatelessWidget {
  final String path;
  final double size;

  const UserFileImageComponent({
    required this.path,
    required this.size,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final sizeBasedValue = size * 0.35;

    return ExtendedImage.file(
      File(path),
      width: size,
      height: size,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(sizeBasedValue),
      shape: BoxShape.rectangle,
      loadStateChanged: (state) {
        if (state.extendedImageLoadState == LoadState.loading) {
          return Padding(
            padding: EdgeInsets.all(sizeBasedValue),
            child: const CircularProgressIndicator(),
          );
        } else {
          if (state.extendedImageInfo == null) {
            return Image.asset(UrlUtil.icon);
          }
        }
      },
    );
  }
}
