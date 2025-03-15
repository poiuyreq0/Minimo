import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimo/screens/user_image_screen.dart';
import 'package:minimo/utils/url_util.dart';

class UserNetworkImageComponent extends StatelessWidget {
  final int? userId;
  final double size;
  final bool cache;
  final bool isClickable;


  const UserNetworkImageComponent({
    required this.userId,
    required this.size,
    required this.cache,
    this.isClickable = true,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final sizeBasedValue = size * 0.35;

    return GestureDetector(
      onTap: isClickable ? () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => UserImageScreen(userId: userId),)
        );
      } : null,
      child: Builder(
        builder: (context) {
          if (userId != null) {
            return FutureBuilder<String?>(
              future: auth.currentUser!.getIdToken(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox(
                    width: size,
                    height: size,
                    child: Padding(
                      padding: EdgeInsets.all(sizeBasedValue),
                      child: const CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return ExtendedImage.network(
                    UrlUtil.getUserImageUrl(userId!),
                    cache: cache,
                    headers: {
                      'Authorization': 'Bearer ${snapshot.data}',
                    },
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(sizeBasedValue),
                    shape: BoxShape.rectangle,
                    loadStateChanged: (state) {
                      if (state.extendedImageLoadState == LoadState.loading || state.extendedImageInfo == null) {
                        return Padding(
                          padding: EdgeInsets.all(sizeBasedValue),
                          child: const CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                }
              }
            );
          } else {
            // (알 수 없음) 이미지
            return ExtendedImage.asset(
              UrlUtil.iconUnknownUser,
              width: size,
              height: size,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(sizeBasedValue),
              shape: BoxShape.rectangle,
            );
          }
        },
      ),
    );
  }
}
