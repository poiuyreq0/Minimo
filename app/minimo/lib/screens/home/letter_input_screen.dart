import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:minimo/components/forms/content_form_component.dart';
import 'package:minimo/components/forms/date_time_form_component.dart';
import 'package:minimo/components/forms/dropdown_form_component.dart';
import 'package:minimo/components/forms/input_form_container.dart';
import 'package:minimo/components/forms/text_form_component.dart';
import 'package:minimo/components/title_component.dart';
import 'package:minimo/enums/gender.dart';
import 'package:minimo/enums/letter_option.dart';
import 'package:minimo/enums/mbti.dart';
import 'package:minimo/models/letter_content_model.dart';
import 'package:minimo/models/letter_model.dart';
import 'package:minimo/models/user_info_model.dart';
import 'package:minimo/providers/letter_provider.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/date_picker_util.dart';
import 'package:minimo/utils/form_validate_util.dart';
import 'package:minimo/utils/snack_bar_util.dart';
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
  Mbti? selectedMbti;
  Gender? selectedGender;
  DateTime? selectedBirthday;
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
                    const SizedBox(height: 16),
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
                      DateTimeFormComponent(
                        label: '생일',
                        hintText: '생일을 선택해 주세요.',
                        controller: birthdayTextController,
                        onTap: () => DatePickerUtil.showCustomDatePicker(
                            context: context,
                            initialDate: selectedBirthday,
                            onDateChange: (value) {
                              if (value != null && value != selectedBirthday) {
                                setState(() {
                                  selectedBirthday = value;
                                  birthdayTextController.text = DateFormat('yyyy-MM-dd').format(selectedBirthday!);
                                });
                              }
                            }
                        ),
                        validator: (value) => FormValidateUtil.validateLength(value),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                TitleComponent(
                  title: '편지 작성',
                ),
                InputFormContainer(
                  children: [
                    TextFormComponent(
                      label: '제목',
                      hintText: '개인 정보가 노출되지 않도록 주의 바랍니다.',
                      initialValue: selectedTitle,
                      onChanged: (value) => selectedTitle = value,
                      validator: (value) => FormValidateUtil.validateLength(value),
                    ),
                    const SizedBox(height: 8),
                    ContentFormComponent(
                      label: '내용',
                      hintText: '개인 정보가 노출되지 않도록 주의 바랍니다.',
                      initialValue: selectedContent,
                      onChanged: (value) => selectedContent = value,
                      validator: (value) => FormValidateUtil.validateContent(value),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: AppStyle.getPositiveElevatedButtonStyle(context),
                  onPressed: () => onSavePressed(context),
                  child: Text('유리병 편지 띄우기'),
                ),
                const SizedBox(height: 32),
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
        SnackBarUtil.showCustomSnackBar(context, '띄우기에 성공했습니다!\n유리병 편지는 편지함에서 확인할 수 있습니다.');

      } catch (e) {
        SnackBarUtil.showCommonErrorSnackBar(context);
      }
    }
  }
}
