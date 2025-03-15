import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimo/utils/url_util.dart';

class UserImageScreen extends StatelessWidget {
  final int? userId;

  const UserImageScreen({
    required this.userId,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height,
            child: Builder(
              builder: (context) {
                if (userId != null) {
                  return FutureBuilder<String?>(
                    future: auth.currentUser!.getIdToken(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      } else {
                        return ExtendedImage.network(
                          UrlUtil.getUserImageUrl(userId!),
                          cache: false,
                          headers: {
                            'Authorization': 'Bearer ${snapshot.data}',
                          },
                          fit: BoxFit.contain,
                          loadStateChanged: (state) {
                            if (state.extendedImageLoadState == LoadState.loading || state.extendedImageInfo == null) {
                              return const SizedBox.shrink();
                            }
                          },
                          mode: ExtendedImageMode.gesture,
                        );
                      }
                    },
                  );
                } else {
                  return ExtendedImage.asset(
                    UrlUtil.iconUnknownUser,
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.gesture,
                  );
                }
              },
            ),
          ),
          SafeArea(
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
