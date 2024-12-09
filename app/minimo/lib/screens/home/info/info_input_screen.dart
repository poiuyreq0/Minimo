import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:minimo/components/forms/date_time_form_component.dart';
import 'package:minimo/components/forms/dropdown_form_component.dart';
import 'package:minimo/components/forms/input_form_container.dart';
import 'package:minimo/components/forms/text_form_component.dart';
import 'package:minimo/components/title_component.dart';
import 'package:minimo/consts/gender.dart';
import 'package:minimo/consts/mbti.dart';
import 'package:minimo/models/user_info_model.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/form_validate_util.dart';
import 'package:minimo/utils/snack_bar_util.dart';
import 'package:provider/provider.dart';

class InfoInputScreen extends StatefulWidget {
  const InfoInputScreen({super.key});

  @override
  State<InfoInputScreen> createState() => _InfoInputScreenState();
}

class _InfoInputScreenState extends State<InfoInputScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late final TextEditingController birthdayTextController;

  String? selectedName;
  Mbti? selectedMbti;
  Gender? selectedGender;
  DateTime? selectedBirthday;

  @override
  void initState() {
    super.initState();

    final userInfo = context.read<UserProvider>().userCache!.userInfo;
    selectedName = userInfo.name;
    selectedMbti = userInfo.mbti;
    selectedGender = userInfo.gender;
    selectedBirthday = userInfo.birthday;

    birthdayTextController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(selectedBirthday!));
  }

  @override
  void dispose() {
    birthdayTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('내 정보 변경'),
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
                  title: '내 정보',
                  helpText: '작성한 정보를 바탕으로 나에게 맞는 유리병 편지를 건질 수 있습니다.',
                ),
                InputFormContainer(
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
                    DateTimeFormComponent(
                      label: '생일',
                      hintText: '생일을 선택해 주세요.',
                      controller: birthdayTextController,
                      onTap: () => selectDate(context),
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
        birthdayTextController.text = DateFormat('yyyy-MM-dd').format(selectedBirthday!);
      });
    }
  }

  Future<void> onSavePressed(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      // formKey.currentState!.save();
      
      UserInfoModel userInfoModel = UserInfoModel(
        name: selectedName,
        mbti: selectedMbti,
        gender: selectedGender,
        birthday: selectedBirthday,
      );
      UserProvider userProvider = context.read<UserProvider>();
      
      try {
        await userProvider.updateUserInfo(userInfoModel: userInfoModel);
        Navigator.of(context).pop();
        SnackBarUtil.showCustomSnackBar(context, '내 정보가 변경되었습니다.');

      } catch (e) {
        SnackBarUtil.showCommonErrorSnackBar(context);
      }
    }
  }
}
