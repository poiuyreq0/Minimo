import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimo/components/text_form_component.dart';
import 'package:minimo/components/title_component.dart';
import 'package:minimo/providers/letter_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/screens/auth_screen.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/form_validate_util.dart';
import 'package:provider/provider.dart';

class UserDeleteScreen extends StatefulWidget {
  const UserDeleteScreen({super.key});

  @override
  State<UserDeleteScreen> createState() => _UserDeleteScreenState();
}

class _UserDeleteScreenState extends State<UserDeleteScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('회원 탈퇴'),
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
                  decoration: AppStyle.getMainBoxDecoration(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormComponent(
                        label: '비밀번호',
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () => onSavePressed(context),
                  child: Text('회원 탈퇴'),
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
      LetterProvider letterProvider = context.read<LetterProvider>();

      try {
        await userProvider.deleteUser(password: password!);
        letterProvider.logout();

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => AuthScreen(),),
              (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('그동안 Minimo를 이용해 주셔서 감사합니다.'),
            )
        );

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('회원 탈퇴에 실패했습니다.\n비밀번호가 올바르게 입력되었는지 확인해 주세요.'),
            )
        );
      }
    }
  }
}
