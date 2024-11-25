import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:minimo/components/dropdown_form_component.dart';
import 'package:minimo/components/text_form_component.dart';
import 'package:minimo/components/title_component.dart';
import 'package:minimo/consts/gender.dart';
import 'package:minimo/consts/letter_option.dart';
import 'package:minimo/consts/mbti.dart';
import 'package:minimo/models/letter_content_model.dart';
import 'package:minimo/models/letter_model.dart';
import 'package:minimo/models/user_info_model.dart';
import 'package:minimo/providers/letter_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/form_validate_util.dart';
import 'package:provider/provider.dart';

class LetterInputScreen extends StatefulWidget {
  const LetterInputScreen({super.key});

  @override
  State<LetterInputScreen> createState() => _LetterInputScreenState();
}

class _LetterInputScreenState extends State<LetterInputScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController birthdayController = TextEditingController();

  LetterOption selectedOption = LetterOption.ALL;
  String? selectedReceiverName;
  Mbti? selectedMbti;
  Gender? selectedGender;
  DateTime? selectedBirthday;
  String? selectedTitle;
  String? selectedContent;

  @override
  void dispose() {
    birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Decoration decoration = AppStyle.getMainBoxDecoration(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('유리병 편지 띄우기'),
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
                  helpText: '작성하신 수신자 정보를 바탕으로 유리병 편지가 전달됩니다.',
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16,),
                  alignment: Alignment.center,
                  decoration: decoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      const SizedBox(height: 16,),
                      if (selectedOption == LetterOption.ALL || selectedOption == LetterOption.NAME)
                        TextFormComponent(
                          label: '수신자 이름 초성',
                          hintText: '이름의 초성을 입력해 주세요.',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[ㄱ-ㅎ]')),
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          initialValue: selectedReceiverName,
                          onChanged: (value) => selectedReceiverName = value,
                          validator: (value) => FormValidateUtil.validateLength(value),
                        ),
                      if (selectedOption == LetterOption.ALL || selectedOption == LetterOption.MBTI)
                        DropdownFormComponent<Mbti>(
                          label: 'MBTI',
                          value: selectedMbti,
                          items: Mbti.values,
                          onChanged: (value) => selectedMbti = value,
                          validator: (value) => FormValidateUtil.validateNotNull<Mbti>(value),
                        ),
                      if (selectedOption == LetterOption.ALL || selectedOption == LetterOption.GENDER)
                        DropdownFormComponent<Gender>(
                          label: '성별',
                          value: selectedGender,
                          items: Gender.values,
                          onChanged: (value) => selectedGender = value,
                          validator: (value) => FormValidateUtil.validateNotNull<Gender>(value),
                        ),
                      if (selectedOption == LetterOption.ALL)
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
                TitleComponent(
                  title: '편지 작성',
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                  alignment: Alignment.center,
                  decoration: decoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormComponent(
                        label: '제목',
                        hintText: '개인 정보가 노출되지 않도록 주의 바랍니다.',
                        initialValue: selectedTitle,
                        onChanged: (value) => selectedTitle = value,
                        validator: (value) => FormValidateUtil.validateLength(value),
                      ),
                      const SizedBox(height: 8,),
                      TextFormComponent(
                        label: '내용',
                        hintText: '개인 정보가 노출되지 않도록 주의 바랍니다.',
                        isContent: true,
                        initialValue: selectedContent,
                        onChanged: (value) => selectedContent = value,
                        validator: (value) => FormValidateUtil.validateContent(value),
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
                  child: Text('유리병 편지 띄우기'),
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

      LetterProvider letterProvider = context.read<LetterProvider>();
      UserProvider userProvider = context.read<UserProvider>();

      LetterModel letterModel = LetterModel(
        id: 0,  // 임시 Id
        senderId: userProvider.userCache!.id,
        letterContent: LetterContentModel(
          title: selectedTitle!,
          content: selectedContent!,
        ),
        letterOption: selectedOption,
        userInfo: UserInfoModel(
          name: selectedReceiverName,
          mbti: selectedMbti,
          gender: selectedGender,
          birthday: selectedBirthday,
        ),
      );

      try {
        await letterProvider.sendLetter(letterModel: letterModel);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('띄우기에 성공했습니다!\n유리병 편지는 편지함에서 확인할 수 있습니다.'),
            )
        );

      } on DioException catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('편지 전송에 실패했습니다.'),
            )
        );
      }
    }
  }
}
