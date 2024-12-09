import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimo/components/forms/input_form_container.dart';
import 'package:minimo/components/forms/text_form_component.dart';
import 'package:minimo/components/title_component.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/form_validate_util.dart';
import 'package:minimo/utils/snack_bar_util.dart';
import 'package:provider/provider.dart';

class NicknameInputScreen extends StatefulWidget {
  const NicknameInputScreen({super.key});

  @override
  State<NicknameInputScreen> createState() => _NicknameInputScreenState();
}

class _NicknameInputScreenState extends State<NicknameInputScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String? selectedNickname;

  @override
  void initState() {
    super.initState();

    UserProvider userProvider = context.read<UserProvider>();
    selectedNickname = userProvider.userCache!.nickname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('닉네임 변경'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TitleComponent(
                  title: '닉네임',
                  helpText: '유리병 편지에 함께 적어 보내는 이름입니다.',
                ),
                InputFormContainer(
                  children: [
                    TextFormComponent(
                      label: '닉네임',
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
                      initialValue: selectedNickname,
                      onChanged: (value) => selectedNickname = value,
                      validator: (value) => FormValidateUtil.validateLength(value),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: AppStyle.getPositiveElevatedButtonStyle(context),
                  onPressed: () => onSavePressed(context),
                  child: Text('확인'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onSavePressed(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      // formKey.currentState!.save();

      UserProvider userProvider = context.read<UserProvider>();

      try {
        await userProvider.updateNickname(nickname: selectedNickname!);
        Navigator.of(context).pop();
        SnackBarUtil.showCustomSnackBar(context, '닉네임이 변경되었습니다.');

      } catch (e) {
        if (e is DioException && e.response?.statusCode == HttpStatus.conflict) {
          SnackBarUtil.showCustomSnackBar(context, '이미 사용 중인 닉네임입니다.');
        } else {
          SnackBarUtil.showCommonErrorSnackBar(context);
        }
      }
    }
  }
}
