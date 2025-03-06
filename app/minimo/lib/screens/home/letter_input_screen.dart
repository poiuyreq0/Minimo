import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:minimo/components/forms/content_form_component.dart';
import 'package:minimo/components/forms/date_time_form_component.dart';
import 'package:minimo/components/forms/dropdown_form_component.dart';
import 'package:minimo/components/forms/input_form_container.dart';
import 'package:minimo/components/forms/text_form_component.dart';
import 'package:minimo/components/forms/title_form_component.dart';
import 'package:minimo/components/images/bottle_icon_component.dart';
import 'package:minimo/components/title_component.dart';
import 'package:minimo/enums/gender.dart';
import 'package:minimo/enums/item.dart';
import 'package:minimo/enums/letter_option.dart';
import 'package:minimo/enums/mbti.dart';
import 'package:minimo/models/letter_content_model.dart';
import 'package:minimo/models/letter_model.dart';
import 'package:minimo/models/user_info_model.dart';
import 'package:minimo/providers/letter_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/date_picker_util.dart';
import 'package:minimo/utils/dialog_util.dart';
import 'package:minimo/utils/form_validate_util.dart';
import 'package:minimo/utils/snack_bar_util.dart';
import 'package:minimo/utils/time_stamp_util.dart';
import 'package:provider/provider.dart';

class LetterInputScreen extends StatefulWidget {
  const LetterInputScreen({super.key});

  @override
  State<LetterInputScreen> createState() => _LetterInputScreenState();
}

class _LetterInputScreenState extends State<LetterInputScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late final TextEditingController birthdayTextController;

  LetterOption selectedOption = LetterOption.ALL;
  String? selectedReceiverName;
  Mbti? selectedReceiverMbti;
  Gender? selectedReceiverGender;
  DateTime? selectedReceiverBirthday;
  String? selectedTitle;
  String? selectedContent;

  @override
  void initState() {
    super.initState();
    birthdayTextController = TextEditingController();
  }

  @override
  void dispose() {
    birthdayTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('편지 쓰기'),
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
                  title: '수신자 정보 입력',
                  helpText: '작성한 수신자 정보를 바탕으로 유리병 편지가 전달됩니다.',
                ),
                InputFormContainer(
                  children: [
                    DropdownFormComponent<LetterOption>(
                      label: '수신자 옵션',
                      value: selectedOption,
                      items: LetterOption.values,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                      validator: (value) => FormValidateUtil.validateNotNull<LetterOption>(value),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (selectedOption != LetterOption.NONE)
                  InputFormContainer(
                    children: [
                      if (selectedOption == LetterOption.ALL || selectedOption == LetterOption.NAME)
                        TextFormComponent(
                          label: '수신자 이름 초성',
                          hintText: '예) 홍길동 -> ㅎㄱㄷ',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[ㄱ-ㅎ]')),
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          onChanged: (value) => selectedReceiverName = value,
                          validator: (value) => FormValidateUtil.validateLength(value),
                        ),
                      if (selectedOption == LetterOption.ALL || selectedOption == LetterOption.MBTI)
                        DropdownFormComponent<Mbti>(
                          label: 'MBTI',
                          value: selectedReceiverMbti,
                          items: Mbti.values,
                          onChanged: (value) => selectedReceiverMbti = value,
                          validator: (value) => FormValidateUtil.validateNotNull<Mbti>(value),
                        ),
                      if (selectedOption == LetterOption.ALL || selectedOption == LetterOption.GENDER)
                        DropdownFormComponent<Gender>(
                          label: '성별',
                          value: selectedReceiverGender,
                          items: Gender.values,
                          onChanged: (value) => selectedReceiverGender = value,
                          validator: (value) => FormValidateUtil.validateNotNull<Gender>(value),
                        ),
                      if (selectedOption == LetterOption.ALL)
                        DateTimeFormComponent(
                          label: '생일',
                          controller: birthdayTextController,
                          onTap: () => DatePickerUtil.showCustomDatePicker(
                              context: context,
                              initialDate: selectedReceiverBirthday,
                              onDateChange: (value) {
                                if (value != null && value != selectedReceiverBirthday) {
                                  setState(() {
                                    selectedReceiverBirthday = value;
                                    birthdayTextController.text = TimeStampUtil.getBirthdayTimeStamp(selectedReceiverBirthday!);
                                  });
                                }
                              }
                          ),
                          validator: (value) => FormValidateUtil.validateLength(value),
                        ),
                    ],
                  ),
                const SizedBox(height: 24),
                TitleComponent(
                  title: '편지 작성',
                ),
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
                      validator: (value) => FormValidateUtil.validateContent(value),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: AppStyle.getPositiveElevatedButtonStyle(context),
                  onPressed: () => _showSendLetterDialog(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('유리병 편지 띄우기'),
                      const SizedBox(width: 4),
                      BottleIconComponent(),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSendLetterDialog(BuildContext context) {
    if (formKey.currentState!.validate()) {
      DialogUtil.showCustomDialog(
        context: context,
        title: '유리병 띄우기',
        widgetContent: Text.rich(
          TextSpan(
            children: [
              WidgetSpan(child: BottleIconComponent()),
              TextSpan(
                text: '를 하나 소모합니다.',
                style: AppStyle.getMediumTextStyle(context),
              ),
            ],
          ),
        ),
        positiveText: '띄우기',
        onPositivePressed: () async {
          final bottleNum = context.read<UserProvider>().userCache!.bottleNum;
          if (bottleNum <= 0) {
            Navigator.of(context).pop();
            SnackBarUtil.showCustomWidgetSnackBar(
              context: context,
              content: Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(child: BottleIconComponent()),
                    TextSpan(
                      text: '가 부족합니다.',
                    ),
                  ],
                ),
              ),
            );
          } else {
            _onSavePressed(context);
          }
        },
        negativeText: '닫기',
        onNegativePressed: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  Future<void> _onSavePressed(BuildContext context) async {
    LetterProvider letterProvider = context.read<LetterProvider>();
    UserProvider userProvider = context.read<UserProvider>();
    final userId = userProvider.userCache!.id;

    LetterModel letterModel = LetterModel(
      id: 0,  // 임시 id
      senderId: userId,
      letterContent: LetterContentModel(
        title: selectedTitle!,
        content: selectedContent!,
      ),
      letterOption: selectedOption,
      userInfo: UserInfoModel(
        name: selectedReceiverName,
        mbti: selectedReceiverMbti,
        gender: selectedReceiverGender,
        birthday: selectedReceiverBirthday,
      ),
    );

    try {
      await letterProvider.sendLetter(letter: letterModel);
      await userProvider.getItemNum(item: Item.BOTTLE);

      Navigator.of(context).popUntil(
            (route) => route.isFirst,
      );
      SnackBarUtil.showCustomSnackBar(context, '띄우기에 성공했습니다!');

    } catch (e) {
      Navigator.of(context).pop();
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
