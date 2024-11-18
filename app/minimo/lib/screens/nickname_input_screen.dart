import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimo/components/text_form_component.dart';
import 'package:minimo/components/title_component.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/form_validate_util.dart';
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
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                  alignment: Alignment.center,
                  decoration: AppStyle.getMainBoxDecoration(Theme.of(context).colorScheme.onPrimary),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormComponent(
                        label: '닉네임',
                        hintText: '유리병 편지에 함께 적어 보내는 이름입니다.',
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        initialValue: selectedNickname,
                        onChanged: (value) => selectedNickname = value,
                        validator: (value) => FormValidateUtil.validateLength(value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
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
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('닉네임이 변경되었습니다.'),
            )
        );

      } on DioException catch (e) {
        if (e.response?.statusCode == HttpStatus.conflict) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.response!.data['message']),
              )
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('닉네임 변경에 실패했습니다.'),
              )
          );
        }
      }
    }
  }
}
