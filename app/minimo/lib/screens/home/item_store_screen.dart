import 'package:flutter/material.dart';
import 'package:minimo/components/ads/banner_ad_component.dart';
import 'package:minimo/components/images/bottle_icon_component.dart';
import 'package:minimo/components/images/net_icon_component.dart';
import 'package:minimo/components/ads/reward_ad_component.dart';
import 'package:minimo/enums/item.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:provider/provider.dart';

class ItemStoreScreen extends StatelessWidget {
  const ItemStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('아이템 상점'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24, top: 4),
            child: Row(
              children: [
                Container(
                  constraints: const BoxConstraints.tightFor(),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                  decoration: AppStyle.getSubBoxDecoration(context),
                  child: Row(
                    children: [
                      NetIconComponent(),
                      const SizedBox(width: 4),
                      Selector<UserProvider, int>(
                        selector: (context, userProvider) => userProvider.userCache!.netNum,
                        builder: (context, netNum, child) {
                          if (netNum < 100) {
                            return Text(
                              '$netNum',
                              style: AppStyle.getMediumTextStyle(context),
                            );
                          } else {
                            return Text(
                              '99+',
                              style: AppStyle.getMediumTextStyle(context),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      BottleIconComponent(),
                      const SizedBox(width: 4),
                      Selector<UserProvider, int>(
                        selector: (context, userProvider) => userProvider.userCache!.bottleNum,
                        builder: (context, bottleNum, child) {
                          if (bottleNum < 100) {
                            return Text(
                              '$bottleNum',
                              style: AppStyle.getMediumTextStyle(context),
                            );
                          } else {
                            return Text(
                              '99+',
                              style: AppStyle.getMediumTextStyle(context),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          BannerAdComponent(
            padding: 16,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: RewardAdComponent(
                    item: Item.NET,
                    count: 5,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: RewardAdComponent(
                    item: Item.BOTTLE,
                    count: 5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
