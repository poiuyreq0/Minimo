import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:minimo/components/dropdown_form_component.dart';
import 'package:minimo/components/text_form_component.dart';
import 'package:minimo/components/title_component.dart';
import 'package:minimo/consts/gender.dart';
import 'package:minimo/consts/mbti.dart';
import 'package:minimo/models/user_info_model.dart';
import 'package:minimo/models/user_model.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/screens/auth_screen.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/form_validate_util.dart';
import 'package:minimo/utils/snack_bar_util.dart';
import 'package:provider/provider.dart';

class IntroInputScreen extends StatefulWidget {
  const IntroInputScreen({super.key});

  @override
  State<IntroInputScreen> createState() => _IntroInputScreenState();
}

class _IntroInputScreenState extends State<IntroInputScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController birthdayController = TextEditingController();

  String? selectedNickname;
  String? selectedName;
  Mbti? selectedMbti;
  Gender? selectedGender;
  DateTime? selectedBirthday;

  @override
  void dispose() {
    birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('사용자 정보 입력'),
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
                  decoration: AppStyle.getMainBoxDecoration(context),
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
                TitleComponent(
                  title: '수신 정보',
                  helpText: '작성하신 수신 정보를 바탕으로 나에게 맞는 유리병 편지를 건질 수 있습니다.',
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                  alignment: Alignment.center,
                  decoration: AppStyle.getMainBoxDecoration(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormComponent(
                        label: '이름 초성',
                        hintText: '이름의 초성을 입력해 주세요.',
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[ㄱ-ㅎ]')),
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        initialValue: selectedName,
                        onChanged: (value) => selectedName = value,
                        validator: (value) => FormValidateUtil.validateLength(value),
                      ),
                      DropdownFormComponent<Mbti>(
                        label: 'MBTI',
                        value: selectedMbti,
                        items: Mbti.values,
                        onChanged: (value) => selectedMbti = value,
                        validator: (value) => FormValidateUtil.validateNotNull<Mbti>(value),
                      ),
                      DropdownFormComponent<Gender>(
                        label: '성별',
                        value: selectedGender,
                        items: Gender.values,
                        onChanged: (value) => selectedGender = value,
                        validator: (value) => FormValidateUtil.validateNotNull<Gender>(value),
                      ),
                      GestureDetector(
                        onTap: () => selectDate(context),
                        child: AbsorbPointer(
                          child: TextFormComponent(
                            label: '생일',
                            hintText: '생일을 선택해 주세요.',
                            controller: birthdayController,
                            validator: (value) => FormValidateUtil.validateLength(value),
                          ),
                        ),
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
                  child: Text('저장'),
                ),
                const SizedBox(height: 32,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      locale: const Locale('ko', 'KR'),
      context: context,
      initialDate: selectedBirthday,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null && selectedDate != selectedBirthday) {
      setState(() {
        selectedBirthday = selectedDate;
        birthdayController.text = DateFormat('yyyy-MM-dd').format(selectedBirthday!);
      });
    }
  }

  Future<void> onSavePressed(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      // formKey.currentState!.save();

      UserProvider userProvider = context.read<UserProvider>();

      UserModel userModel = UserModel(
        id: 0,  // 임시 Id
        email: '',  // 임시 email
        nickname: selectedNickname!,
        userInfo: UserInfoModel(
          name: selectedName,
          mbti: selectedMbti,
          gender: selectedGender,
          birthday: selectedBirthday,
        ),
        heartNum: 0, // 임시 heartNum
      );

      try {
        await userProvider.createUser(userModel: userModel);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => AuthScreen(),),
          (route) => false,
        );
        SnackBarUtil.showSnackBar(context, '$selectedNickname 님 환영합니다!');

      } catch (e) {
        if (e is DioException && e.response?.statusCode == HttpStatus.conflict) {
          SnackBarUtil.showSnackBar(context, '이미 사용 중인 닉네임입니다.');
        } else {
          SnackBarUtil.showCommonErrorSnackBar(context);
        }
      }
    }
  }
}
