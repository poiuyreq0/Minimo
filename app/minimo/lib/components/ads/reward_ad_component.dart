import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:minimo/components/images/bottle_icon_component.dart';
import 'package:minimo/components/images/net_icon_component.dart';
import 'package:minimo/enums/item.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/snack_bar_util.dart';
import 'package:provider/provider.dart';

class RewardAdComponent extends StatefulWidget {
  final Item item;
  final int count;

  const RewardAdComponent({
    required this.item,
    required this.count,
    super.key
  });

  @override
  State<RewardAdComponent> createState() => _RewardAdComponentState();
}

class _RewardAdComponentState extends State<RewardAdComponent> {
  late final Widget icon;
  late final String adUnitId;
  RewardedAd? rewardedAd;

  @override
  void initState() {
    super.initState();

    if (widget.item == Item.NET) {
      icon = NetIconComponent(size: 30,);
      adUnitId = 'ca-app-pub-3940256099942544/5224354917';
    } else if (widget.item == Item.BOTTLE) {
      icon = BottleIconComponent(size: 30,);
      adUnitId = 'ca-app-pub-3940256099942544/5224354917';
    }
  }

  @override
  void dispose() {
    rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _loadRewardedAd();
      },
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        decoration: AppStyle.getMainBoxDecoration(context),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon,
                      Text(
                        ' x ${widget.count} ',
                        style: AppStyle.getLargeTextStyle(context),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 32,
                  ),
                  Ink(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: AppStyle.getSubBoxDecoration(context),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.live_tv,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          TextSpan(
                            text: '  AD',
                            style: AppStyle.getLittleButtonTextStyle(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('RewardedAd onAdLoaded: $ad');

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('RewardedAd onAdDismissedFullScreenContent: $ad');
              ad.dispose();
              rewardedAd = null;
            },
          );

          rewardedAd = ad;
          rewardedAd!.show(
            onUserEarnedReward: (_, reward) async {
              debugPrint('RewardedAd onUserEarnedReward reward: ${reward.amount}, ${reward.type}');

              UserProvider userProvider = context.read<UserProvider>();

              try {
                await userProvider.addItemNum(item: widget.item, amount: reward.amount.toInt());

              } catch (e) {
                SnackBarUtil.showCommonErrorSnackBar(context);
              }
            },
          );
        },
        onAdFailedToLoad: (err) {
          debugPrint('RewardedAd onAdFailedToLoad: ${err.message}');
          SnackBarUtil.showCommonErrorSnackBar(context);
        },
      ),
    );
  }
}
