import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minimo/components/ads/banner_ad_component.dart';
import 'package:minimo/components/bottom_text_form_component.dart';
import 'package:minimo/components/comment_element_component.dart';
import 'package:minimo/components/images/user_network_image_component.dart';
import 'package:minimo/enums/report_reason.dart';
import 'package:minimo/models/comment_model.dart';
import 'package:minimo/models/post_model.dart';
import 'package:minimo/models/user_model.dart';
import 'package:minimo/providers/post_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/dialog_util.dart';
import 'package:minimo/utils/notification_util.dart';
import 'package:minimo/utils/snack_bar_util.dart';
import 'package:minimo/utils/time_stamp_util.dart';
import 'package:provider/provider.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel post;

  const PostDetailScreen({
    required this.post,
    super.key
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late final TextEditingController textEditingController;
  late final ScrollController scrollController;
  late final FocusNode focusNode;

  int? selectedParentCommentId;

  @override
  void initState() {
    super.initState();
    NotificationUtil.cancelNotification(widget.post.id, 'comment');
    NotificationUtil.cancelNotification(widget.post.id, 'subComment');

    textEditingController = TextEditingController(text: '',);
    scrollController = ScrollController();
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        selectedParentCommentId = null;
        context.read<PostProvider>().refreshPostDetailScreenBottomTextForm();
      }
    },);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = context.read<PostProvider>();
    final userId = context.read<UserProvider>().userCache!.id;

    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          postProvider.exitPost();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('게시글'),
          actions: [
            PopupMenuButton<String>(
              padding: const EdgeInsets.all(16),
              onSelected: (value) async {
                if (value == '삭제') {
                  DialogUtil.showCustomDialog(
                    context: context,
                    title: '게시글 삭제',
                    content: '게시글을 삭제하시겠습니까?',
                    positiveText: '삭제',
                    onPositivePressed: () async {
                      try {
                        await postProvider.deletePost(postId: widget.post.id);
                        Navigator.of(context).popUntil(
                              (route) => route.isFirst,
                        );

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
                    content: '${widget.post.writerNickname} 님을 신고하시겠습니까?\n',
                    positiveText: '신고',
                    onPositivePressed: () async {
                      UserProvider userProvider = context.read<UserProvider>();

                      try {
                        await userProvider.reportUser(targetId: widget.post.writerId, reportReason: reportReason);

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
                    content: '${widget.post.writerNickname} 님을 차단하시겠습니까?',
                    positiveText: '차단',
                    onPositivePressed: () async {
                      UserProvider userProvider = context.read<UserProvider>();

                      try {
                        await userProvider.banUser(targetId: widget.post.writerId, targetNickname: widget.post.writerNickname);
                        Navigator.of(context).popUntil(
                              (route) => route.isFirst,
                        );

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
                  if (widget.post.writerId == userId)
                    PopupMenuItem<String>(
                      value: '삭제',
                      child: Text(
                        '삭제',
                        style: AppStyle.getLittleButtonTextStyle(context, isPositive: false),
                      ),
                    ),
                  if (widget.post.writerId != userId)
                    PopupMenuItem<String>(
                      value: '신고',
                      child: Text(
                        '신고',
                        style: AppStyle.getLittleButtonTextStyle(context, isPositive: false),
                      ),
                    ),
                  if (widget.post.writerId != userId)
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
        body: Selector<PostProvider, bool>(
          selector: (context, postProvider) => postProvider.postDetailScreenSelectorTrigger,
          builder: (context, _, child) {
            return FutureBuilder<PostModel>(
              future: postProvider.getPost(postId: widget.post.id, userId: userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                } else if (snapshot.hasError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    DialogUtil.showCustomDialog(
                      barrierDismissible: false,
                      context: context,
                      title: '게시글',
                      content: '사라진 게시글입니다.',
                      negativeText: '닫기',
                      onNegativePressed: () {
                        Navigator.of(context)..pop()..pop();
                      },
                    );
                  });
                  return const SizedBox.shrink();
                } else {
                  return Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            setState(() {});
                          },
                          child: SingleChildScrollView(
                            controller: scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                focusNode.unfocus();
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                                    child: Row(
                                      children: [
                                        UserNetworkImageComponent(
                                          userId: snapshot.data!.writerId,
                                          cache: false,
                                          size: 36,
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data!.writerNickname,
                                              style: AppStyle.getLargeTextStyle(context, 16),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              TimeStampUtil.getDetailTimeStamp(snapshot.data!.createdDate),
                                              style:AppStyle.getSmallTextStyle(context, 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    child: Text(
                                      snapshot.data!.postContent.title,
                                      style: AppStyle.getLargeTextStyle(context),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    child: Text(
                                      snapshot.data!.postContent.content,
                                      style: AppStyle.getMediumTextStyle(context),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Divider(
                                    height: 24,
                                    indent: 16,
                                    endIndent: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          postProvider.updatePostLikeNum(postId: widget.post.id, userId: userId);
                                        },
                                        child: Selector<PostProvider, bool>(
                                          selector: (context, postProvider) => postProvider.postDetailScreenPostLikeSelectorTrigger,
                                          builder: (context, _, child) {
                                            final likeNum = postProvider.postCache!.likeNum;
                                            final isLikeSet = postProvider.postCache!.isLikeSet!;

                                            return Container(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  FaIcon(
                                                    isLikeSet ? FontAwesomeIcons.solidThumbsUp : FontAwesomeIcons.thumbsUp,
                                                    color: Theme.of(context).colorScheme.primary,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    '$likeNum',
                                                    style: AppStyle.getLittleButtonTextStyle(context),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        ),
                                      ),
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          FocusScope.of(context).requestFocus(focusNode);
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.comment,
                                              color: Theme.of(context).colorScheme.primary,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${snapshot.data!.commentNum}',
                                              style: AppStyle.getLittleButtonTextStyle(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const Divider(
                                    height: 8,
                                    indent: 16,
                                    endIndent: 16,
                                  ),
                                  const SizedBox(height: 4),
                                  BannerAdComponent(
                                    padding: 16,
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.comments!.length,
                                      itemBuilder: (context, index) {
                                        CommentModel comment = snapshot.data!.comments![index];

                                        return CommentElementComponent(
                                          comment: comment,
                                          postWriterId: snapshot.data!.writerId,
                                          onCommentButtonPressed: () {
                                            selectedParentCommentId = comment.id;
                                            postProvider.refreshPostDetailScreenBottomTextForm();
                                            FocusScope.of(context).requestFocus(focusNode);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Selector<PostProvider, bool>(
                        selector: (context, postProvider) => postProvider.postDetailScreenBottomTextFormSelectorTrigger,
                        builder: (context, _, child) {
                          return BottomTextFormComponent(
                            focusNode: focusNode,
                            hintText: selectedParentCommentId == null ? '댓글 입력' : '대댓글 입력',
                            controller: textEditingController,
                            onPressed: () {
                              _onSendPressed(context);
                            },
                          );
                        }
                      ),
                    ],
                  );
                }
              },
            );
          }
        ),
      ),
    );
  }

  Future<void> _onSendPressed(BuildContext context) async {
    PostProvider postProvider = context.read<PostProvider>();
    UserModel user = context.read<UserProvider>().userCache!;

    final isParentComment = selectedParentCommentId == null;

    final comment = CommentModel(
      id: 0,  // 임시 id
      postId: widget.post.id,
      parentCommentId: selectedParentCommentId,
      writerId: user.id,
      writerNickname: user.nickname,
      content: textEditingController.text,
      likeNum: 0,  // 임시 likeNum
      isVisible: true,  // 임시 isVisible
      isLikeSet: false,  // 임시 isLikeSet
      createdDate: DateTime.now(),  // 임시 createdDate
    );

    try {
      await postProvider.sendComment(comment: comment);

      textEditingController.text = '';
      selectedParentCommentId = null;
      postProvider.refreshPostDetailScreenBottomTextForm();
      focusNode.unfocus();


      if (isParentComment) {
        await Future.delayed(const Duration(milliseconds: 700), () {
          // 스크롤 위치를 맨 아래로 이동
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }

    } catch (e) {
      if (e is DioException && e.response?.statusCode == HttpStatus.forbidden) {
        DialogUtil.showCustomDialog(
          context: context,
          title: '계정 정지',
          content: '계정이 누적 신고로 인해 정지되었습니다.\n일부 기능이 30일 동안 제한되며 추가 신고가 접수될 경우 정지 기간이 연장될 수 있습니다.',
          negativeText: '닫기',
          onNegativePressed: () {
            Navigator.of(context).pop();
          },
        );
      } else {
        SnackBarUtil.showCommonErrorSnackBar(context);
      }
    }
  }
}
