import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdComponent extends StatefulWidget {
  final int padding;

  const BannerAdComponent({
    required this.padding,
    super.key
  });

  @override
  State<BannerAdComponent> createState() => _BannerAdComponentState();
}

class _BannerAdComponentState extends State<BannerAdComponent> {
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/9214589741'
      : 'ca-app-pub-3940256099942544/2435281174';
  BannerAd? bannerAd;

  @override
  void dispose() {
    bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BannerAd>(
      future: _loadAd(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        } else {
          return SizedBox(
            width: snapshot.data!.size.width.toDouble(),
            height: snapshot.data!.size.height.toDouble(),
            child: AdWidget(ad: snapshot.data!),
          );
        }
      },
    );
  }

  Future<BannerAd> _loadAd() async {
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.sizeOf(context).width.truncate() - widget.padding*2
    );

    bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: size!,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('onAdLoaded: $ad');
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd onAdFailedToLoad: ${err.message}');
          ad.dispose();
        },
        onAdImpression: (ad) {
          debugPrint('onAdImpression: $ad');
        },
      ),
    );

    await bannerAd!.load();

    return bannerAd!;
  }
}
