import 'dart:io';

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minimo/components/forms/input_form_container.dart';
import 'package:minimo/components/forms/text_form_component.dart';
import 'package:minimo/components/title_component.dart';
import 'package:minimo/components/user_file_image_component.dart';
import 'package:minimo/components/user_network_image_component.dart';
import 'package:minimo/models/user_model.dart';
import 'package:minimo/providers/user_provider.dart';
import 'package:minimo/styles/app_style.dart';
import 'package:minimo/utils/form_validate_util.dart';
import 'package:minimo/utils/snack_bar_util.dart';
import 'package:provider/provider.dart';

class ProfileInputScreen extends StatefulWidget {
  const ProfileInputScreen({super.key});

  @override
  State<ProfileInputScreen> createState() => _ProfileInputScreenState();
}

class _ProfileInputScreenState extends State<ProfileInputScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  XFile? selectedImage;
  String? selectedNickname;

  @override
  void initState() {
    super.initState();

    UserProvider userProvider = context.read<UserProvider>();
    selectedNickname = userProvider.userCache!.nickname;
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserProvider>().userCache!.id;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('프로필 변경'),
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
                  title: '사진',
                ),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: GestureDetector(
                    onTap: () async {
                      selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (selectedImage != null) {
                        setState(() {});
                      }
                    },
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        (selectedImage == null) ? UserNetworkImageComponent(
                          userId: userId,
                          size: 130,
                        ) : UserFileImageComponent(
                          path: selectedImage!.path,
                          size: 130,
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.photo,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: AppStyle.getPositiveElevatedButtonStyle(context),
                  onPressed: () => onImageSavePressed(context),
                  child: Text('확인'),
                ),
                const SizedBox(height: 24),
                TitleComponent(
                  title: '닉네임',
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
                  onPressed: () => onNicknameSavePressed(context),
                  child: Text('확인'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onImageSavePressed(BuildContext context) async {
    if (selectedImage != null) {
      // formKey.currentState!.save();

      UserProvider userProvider = context.read<UserProvider>();

      try {
        await userProvider.updateImage(image: selectedImage!);
        Navigator.of(context).pop();
        SnackBarUtil.showCustomSnackBar(context, '사진이 변경되었습니다.');

      } catch (e) {
        SnackBarUtil.showCommonErrorSnackBar(context);
      }
    } else {
      SnackBarUtil.showCustomSnackBar(context, '선택된 사진이 없습니다.');
    }
  }

  Future<void> onNicknameSavePressed(BuildContext context) async {
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