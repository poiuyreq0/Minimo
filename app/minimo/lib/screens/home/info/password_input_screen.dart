import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimo/components/forms/input_form_container.dart';
import 'package:minimo/components/forms/password_form_component.dart';
import 'package:minimo/components/title_component.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/form_validate_util.dart';
import 'package:minimo/utils/snack_bar_util.dart';
import 'package:provider/provider.dart';

class PasswordInputScreen extends StatefulWidget {
  const PasswordInputScreen({super.key});

  @override
  State<PasswordInputScreen> createState() => _PasswordInputScreenState();
}

class _PasswordInputScreenState extends State<PasswordInputScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String? password;
  String? newPassword;
  String? newPasswordConfirm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 변경'),
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
                  title: '비밀번호 확인',
                ),
                InputFormContainer(
                  children: [
                    PasswordFormComponent(
                      label: '현재 비밀번호',
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
                      onChanged: (value) => password = value,
                      validator: (value) => FormValidateUtil.validateNotEmpty(value),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TitleComponent(
                  title: '새 비밀번호 입력',
                  helpText: '비밀번호는 영문 소문자와 숫자를 포함하여 최소 8자 이상이어야 합니다.',
                ),
                InputFormContainer(
                  children: [
                    PasswordFormComponent(
                      label: '새 비밀번호',
                      hintText: '영문 소문자, 숫자 포함 8자 이상',
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
                      onChanged: (value) => newPassword = value,
                      validator: (value) => FormValidateUtil.validateNotEmpty(value),
                    ),
                    PasswordFormComponent(
                      label: '새 비밀번호 확인',
                      hintText: '새 비밀번호 재입력',
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
                      onChanged: (value) => newPasswordConfirm = value,
                      validator: (value) => FormValidateUtil.validatePassword(value, newPassword),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: AppStyle.getPositiveElevatedButtonStyle(context),
                  onPressed: () => _onSavePressed(context),
                  child: Text('확인'),
                ),
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

      UserProvider userProvider = context.read<UserProvider>();

      try {
        await userProvider.updatePassword(password: password!, newPassword: newPassword!);
        Navigator.of(context).pop();
        SnackBarUtil.showCustomSnackBar(context, '비밀번호가 변경되었습니다.');

      } catch (e) {
        if (e is FirebaseAuthException) {
          if (e.code == 'invalid-credential') {
            SnackBarUtil.showCustomSnackBar(context, '비밀번호가 맞지 않습니다.');
          } else if (e.code == 'unknown') {
            SnackBarUtil.showCustomSnackBar(context, '비밀번호는 영문 소문자와 숫자를 포함하여 최소 8자 이상이어야 합니다.');
          }
        } else {
          SnackBarUtil.showCommonErrorSnackBar(context);
        }
      }
    }
  }
}
