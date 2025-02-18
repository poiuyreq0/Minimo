import 'package:flutter/material.dart';
import 'package:minimo/components/user_ban_record_element_component.dart';
import 'package:minimo/models/user_ban_record_model.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/dialog_util.dart';
import 'package:minimo/utils/snack_bar_util.dart';
import 'package:provider/provider.dart';

class UserBanListScreen extends StatelessWidget {
  const UserBanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사용자 차단 관리'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Selector<UserProvider, bool>(
                selector: (context, userProvider) => userProvider.userBanListScreenSelectorTrigger,
                builder: (context, _, child) {
                  List<UserBanRecordModel> userBanRecords = context.read<UserProvider>().userCache!.userBanRecordMap!.values.toList();

                  if (userBanRecords.isEmpty) {
                    return Text(
                      '차단된 사용자가 없습니다.',
                      style: AppStyle.getHintTextStyle(context),
                    );
                  } else {
                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: userBanRecords.length,
                      itemBuilder: (context, index) {
                        UserBanRecordModel userBanRecord = userBanRecords[index];

                        return UserBanRecordElementComponent(
                          userBanRecord: userBanRecord,
                          onTap: () {
                            DialogUtil.showCustomDialog(
                              context: context,
                              title: '차단 해제',
                              content: '${userBanRecord.targetNickname} 님을 차단 해제하시겠습니까?',
                              positiveText: '해제',
                              onPositivePressed: () async {
                                UserProvider userProvider = context.read<UserProvider>();

                                try {
                                  await userProvider.unbanUser(targetId: userBanRecord.targetId);
                                  Navigator.of(context).pop();

                                } catch (e) {
                                  Navigator.of(context).pop();
                                  SnackBarUtil.showCommonErrorSnackBar(context);
                                }
                              },
                              negativeText: '취소',
                              onNegativePressed: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      },
                    );
                  }
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
