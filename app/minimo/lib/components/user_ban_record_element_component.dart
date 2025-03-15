import 'package:flutter/material.dart';
import 'package:minimo/components/images/user_network_image_component.dart';
import 'package:minimo/models/user_ban_record_model.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/time_stamp_util.dart';

class UserBanRecordElementComponent extends StatelessWidget {
  final UserBanRecordModel userBanRecord;
  final GestureTapCallback? onTap;

  const UserBanRecordElementComponent({
    required this.userBanRecord,
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            UserNetworkImageComponent(
              userId: userBanRecord.targetId,
              size: 55,
              cache: false,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                userBanRecord.targetNickname,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyle.getLargeTextStyle(context, 16),
              ),
            ),
            const SizedBox(width: 24),
            Text(
              TimeStampUtil.getElementTimeStamp(userBanRecord.createdDate),
              maxLines: 1,
              style:AppStyle.getSmallTextStyle(context, 12),
            ),
          ],
        ),
      ),
    );
  }
}
