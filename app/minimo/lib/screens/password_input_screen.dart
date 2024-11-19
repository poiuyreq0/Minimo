import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimo/components/text_form_component.dart';
import 'package:minimo/components/title_component.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/form_validate_util.dart';
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
      resizeToAvoidBottomInset: true,
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
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                  alignment: Alignment.center,
                  decoration: AppStyle.getMainBoxDecoration(Theme.of(context).colorScheme.onPrimary),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormComponent(
                        label: '현재 비밀번호',
                        isPassword: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        onChanged: (value) => password = value,
                        validator: (value) => FormValidateUtil.validateNotEmpty(value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16,),
                TitleComponent(
                  title: '새 비밀번호 입력',
                  helpText: '6글자 이상',
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                  alignment: Alignment.center,
                  decoration: AppStyle.getMainBoxDecoration(Theme.of(context).colorScheme.onPrimary),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormComponent(
                        label: '새 비밀번호',
                        hintText: '6글자 이상',
                        isPassword: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        onChanged: (value) => newPassword = value,
                        validator: (value) => FormValidateUtil.validateNotEmpty(value),
                      ),

                      TextFormComponent(
                        label: '새 비밀번호 확인',
                        hintText: '새 비밀번호를 다시 한번 입력해 주세요.',
                        isPassword: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        onChanged: (value) => newPasswordConfirm = value,
                        validator: (value) => validatePassword(value),
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
        await userProvider.updatePassword(password: password!, newPassword: newPassword!);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('비밀번호가 변경되었습니다.'),
            )
        );

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('비밀번호 변경에 실패했습니다.\n비밀번호가 올바르게 입력되었는지 확인해 주세요.'),
            )
        );
      }
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '필드가 비어있습니다.';
    } else if (value != newPassword) {
      return '비밀번호가 서로 다릅니다.';
    }

    return null;
  }
}
