import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:minimo/utils/url_util.dart';

class UserNetworkImageComponent extends StatelessWidget {
  final int? userId;
  final double size;

  const UserNetworkImageComponent({
    required this.userId,
    required this.size,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final sizeBasedValue = size * 0.35;

    return (userId != null) ? ExtendedImage.network(
      UrlUtil.getUserImageUrl(userId!),
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
    ) : ExtendedImage.asset(
      UrlUtil.icon,
      width: size,
      height: size,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(sizeBasedValue),
      shape: BoxShape.rectangle,
    );
  }
}
