import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:minimo/components/forms/content_form_component.dart';
import 'package:minimo/components/forms/input_form_container.dart';
import 'package:minimo/components/forms/title_form_component.dart';
import 'package:minimo/enums/bottom_navigation.dart';
import 'package:minimo/models/post_content_model.dart';
import 'package:minimo/models/post_model.dart';
import 'package:minimo/models/user_model.dart';
import 'package:minimo/providers/post_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/screens/auth_screen.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/dialog_util.dart';
import 'package:minimo/utils/form_validate_util.dart';
import 'package:minimo/utils/snack_bar_util.dart';
import 'package:provider/provider.dart';

class PostInputScreen extends StatefulWidget {
  const PostInputScreen({super.key});

  @override
  State<PostInputScreen> createState() => _PostInputScreenState();
}

class _PostInputScreenState extends State<PostInputScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();

  String? selectedTitle;
  String? selectedContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 쓰기'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InputFormContainer(
                  children: [
                    TitleFormComponent(
                      label: '제목',
                      hintText: '과도한 개인 정보 노출에 주의 바랍니다.',
                      onChanged: (value) => selectedTitle = value,
                      validator: (value) => FormValidateUtil.validateLength(value),
                    ),
                    const SizedBox(height: 8),
                    ContentFormComponent(
                      label: '내용',
                      hintText: '과도한 개인 정보 노출에 주의 바랍니다.',
                      onChanged: (value) => selectedContent = value,
                      validator: (value) => FormValidateUtil.validateLength(value),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: AppStyle.getPositiveElevatedButtonStyle(context),
                  onPressed: () => _onSavePressed(context),
                  child: Text('게시글 등록'),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSavePressed(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      // formKey.currentState!.save();

      PostProvider postProvider = context.read<PostProvider>();
      UserModel user = context.read<UserProvider>().userCache!;

      PostModel postModel = PostModel(
        id: 0,  // 임시 id
        writerId: user.id,
        writerNickname: user.nickname,
        postContent: PostContentModel(
          title: selectedTitle!,
          content: selectedContent!,
        ),
        likeNum: 0,  // 임시 likeNum
        commentNum: 0,  // 임시 commentNum
        createdDate: DateTime.now(),  // 임시 createdDate
      );

      try {
        await postProvider.createPost(post: postModel);

        Navigator.of(context).pop();
        SnackBarUtil.showCustomSnackBar(context, '게시글이 등록되었습니다.');

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
}
