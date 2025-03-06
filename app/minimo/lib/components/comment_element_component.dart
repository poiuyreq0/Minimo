import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minimo/components/images/user_network_image_component.dart';
import 'package:minimo/enums/report_reason.dart';
import 'package:minimo/models/comment_model.dart';
import 'package:minimo/models/user_ban_record_model.dart';
import 'package:minimo/providers/post_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/dialog_util.dart';
import 'package:minimo/utils/snack_bar_util.dart';
import 'package:minimo/utils/time_stamp_util.dart';
import 'package:provider/provider.dart';

class CommentElementComponent extends StatelessWidget {
  final CommentModel comment;
  final int postWriterId;
  final VoidCallback? onCommentButtonPressed;

  const CommentElementComponent({
    required this.comment,
    required this.postWriterId,
    required this.onCommentButtonPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (comment.isVisible || !comment.isVisible && comment.comments!.isNotEmpty) {
          return Column(
            children: [
              _comment(
                context: context,
                comment: comment,
                isSubComment: false,
              ),
              if (comment.comments!.isNotEmpty)
                ...comment.comments!.map(
                      (subComment) {
                    if (subComment.isVisible) {
                      return _comment(
                        context: context,
                        comment: subComment,
                        isSubComment: true,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ).toList(),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    );
  }

  Widget _comment({
    required BuildContext context,
    required CommentModel comment,
    required bool isSubComment,
  }) {
    PostProvider postProvider = context.read<PostProvider>();
    Map<int, UserBanRecordModel> userBanRecordMap = context.read<UserProvider>().userCache!.userBanRecordMap!;
    final userId = context.read<UserProvider>().userCache!.id;

    return Padding(
      padding: isSubComment ? const EdgeInsets.only(left: 30.0) : EdgeInsets.zero,
      child: Card(
        elevation: 0,
        color: isSubComment ? Theme.of(context).colorScheme.surfaceContainer : Theme.of(context).colorScheme.surfaceContainerLow,
        child: Builder(
          builder: (context) {
            if (comment.isVisible && userBanRecordMap[comment.writerId] == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 12),
                      UserNetworkImageComponent(
                        userId: comment.writerId,
                        cache: false,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              comment.writerNickname,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyle.getLargeTextStyle(context, 14),
                            ),
                            if (comment.writerId == postWriterId)
                              Text(
                                ' (글쓴이)',
                                style: AppStyle.getLargeTextStyle(context, 14),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (!isSubComment)
                        IconButton(
                          onPressed: onCommentButtonPressed,
                          icon: FaIcon(
                            FontAwesomeIcons.comment,
                            color: Theme.of(context).colorScheme.tertiary,
                            size: 16,
                          ),
                        ),
                      PopupMenuButton<String>(
                        iconSize: 16,
                        onSelected: (value) async {
                          if (value == '삭제') {
                            DialogUtil.showCustomDialog(
                              context: context,
                              title: '댓글 삭제',
                              content: '댓글을 삭제하시겠습니까?',
                              positiveText: '삭제',
                              onPositivePressed: () async {
                                try {
                                  await postProvider.deleteComment(commentId: comment.id);
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

                          } else if (value == '신고') {
                            late final ReportReason reportReason;

                            await showDialog(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                  title: Text('신고 사유'),
                                  children: ReportReason.values.map<SimpleDialogOption>(
                                        (value) => SimpleDialogOption(
                                      child: Text(value.description),
                                      onPressed: () {
                                        reportReason = value;
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ).toList(),
                                );
                              },
                            );

                            await DialogUtil.showCustomDialog(
                              context: context,
                              title: reportReason.description,
                              content: '${comment.writerNickname} 님을 신고하시겠습니까?\n',
                              positiveText: '신고',
                              onPositivePressed: () async {
                                UserProvider userProvider = context.read<UserProvider>();

                                try {
                                  await userProvider.reportUser(targetId: comment.writerId, reportReason: reportReason);

                                  Navigator.of(context).pop();
                                  SnackBarUtil.showCustomSnackBar(context, '신고가 등록되었습니다.');

                                } catch (e) {
                                  Navigator.of(context).pop();
                                  if (e is DioException && e.response?.statusCode == HttpStatus.conflict) {
                                    SnackBarUtil.showCustomSnackBar(context, '해당 신고는 이미 접수되었습니다.');
                                  } else {
                                    SnackBarUtil.showCommonErrorSnackBar(context);
                                  }
                                }
                              },
                              negativeText: '취소',
                              onNegativePressed: () {
                                Navigator.of(context).pop();
                              },
                            );


                          } else if (value == '차단') {
                            DialogUtil.showCustomDialog(
                              context: context,
                              title: '사용자 차단',
                              content: '${comment.writerNickname} 님을 차단하시겠습니까?',
                              positiveText: '차단',
                              onPositivePressed: () async {
                                UserProvider userProvider = context.read<UserProvider>();

                                try {
                                  await userProvider.banUser(targetId: comment.writerId, targetNickname: comment.writerNickname);
                                  if (comment.writerId == postWriterId) {
                                    Navigator.of(context).popUntil(
                                          (route) => route.isFirst,
                                    );
                                  } else {
                                    postProvider.refreshPostDetailScreen();
                                    Navigator.of(context).pop();
                                  }

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
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            if (comment.writerId == userId)
                              PopupMenuItem<String>(
                                value: '삭제',
                                child: Text(
                                  '삭제',
                                  style: AppStyle.getLittleButtonTextStyle(context, isPositive: false),
                                ),
                              ),
                            if (comment.writerId != userId)
                              PopupMenuItem<String>(
                                value: '신고',
                                child: Text(
                                  '신고',
                                  style: AppStyle.getLittleButtonTextStyle(context, isPositive: false),
                                ),
                              ),
                            if (comment.writerId != userId)
                              PopupMenuItem<String>(
                                value: '차단',
                                child: Text(
                                  '차단',
                                  style: AppStyle.getLittleButtonTextStyle(context, isPositive: false),
                                ),
                              ),
                          ];
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      comment.content,
                      style: AppStyle.getMediumTextStyle(context, 14),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            postProvider.updateCommentLikeNum(commentId: comment.id, userId: userId);
                          },
                          child: Selector<PostProvider, bool>(
                              selector: (context, postProvider) => postProvider.postDetailScreenCommentLikeSelectorTrigger,
                              builder: (context, _, child) {
                                final likeNum = postProvider.commentLikeCache[comment.id]?.likeNum ?? comment.likeNum;
                                final isLikeSet = postProvider.commentLikeCache[comment.id]?.isLikeSet ?? comment.isLikeSet;

                                return IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      FaIcon(
                                        isLikeSet ? FontAwesomeIcons.solidThumbsUp : FontAwesomeIcons.thumbsUp,
                                        color: Theme.of(context).colorScheme.primary,
                                        size: 13,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '$likeNum',
                                        style: AppStyle.getLargeTextStyle(context, 13),
                                      ),
                                      const VerticalDivider(
                                        thickness: 1.2,
                                        indent: 3,
                                        endIndent: 3,
                                      ),
                                    ],
                                  ),
                                );
                              }
                          ),
                        ),
                        Text(
                          TimeStampUtil.getSimpleTimeStamp(comment.createdDate),
                          style:AppStyle.getSmallTextStyle(context, 12),
                        ),
                      ],
                    ),
                  ),
                ],
              );

            } else {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        UserNetworkImageComponent(
                          userId: null,
                          cache: false,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                '(알 수 없음)',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyle.getLargeTextStyle(context, 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      !comment.isVisible ? '삭제된 댓글입니다.' : '차단된 사용자입니다.',
                      style: AppStyle.getMediumTextStyle(context, 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      TimeStampUtil.getSimpleTimeStamp(comment.createdDate),
                      style:AppStyle.getSmallTextStyle(context, 12),
                    ),
                  ],
                ),
              );
            }
          }
        ),
      ),
    );
  }
}
