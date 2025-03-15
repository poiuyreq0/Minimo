import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minimo/components/forms/input_form_container.dart';
import 'package:minimo/components/forms/text_form_component.dart';
import 'package:minimo/components/images/user_network_image_component.dart';
import 'package:minimo/components/title_component.dart';
import 'package:minimo/components/images/user_file_image_component.dart';
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
  bool isReset = false;
  String? selectedNickname;

  @override
  void initState() {
    super.initState();

    UserModel user = context.read<UserProvider>().userCache!;
    isReset = !user.isProfileImageSet;
    selectedNickname = user.nickname;
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = context.read<UserProvider>().userCache!;

    return Scaffold(
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (selectedImage != null) {
                          setState(() {
                            isReset = false;
                          });
                        }
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Builder(
                            builder: (context) {
                              if (isReset) {
                                return UserNetworkImageComponent(
                                  userId: 0,
                                  size: 130,
                                  cache: false,
                                  isClickable: false,
                                );
                              } else if (selectedImage == null) {
                                return UserNetworkImageComponent(
                                  userId: user.id,
                                  size: 130,
                                  cache: false,
                                  isClickable: false,
                                );
                              } else {
                                return UserFileImageComponent(
                                  path: selectedImage!.path,
                                  size: 130,
                                );
                              }
                            },
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.arrowRotateLeft,
                              color: Theme.of(context).colorScheme.tertiary,
                              size: 18,
                            ),
                            onPressed: () {
                              setState(() {
                                isReset = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: AppStyle.getPositiveElevatedButtonStyle(context),
                  onPressed: () => _onImageSavePressed(context),
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
                  onPressed: () => _onNicknameSavePressed(context),
                  child: Text('확인'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onImageSavePressed(BuildContext context) async {
    if (isReset || selectedImage != null) {
      // formKey.currentState!.save();

      UserProvider userProvider = context.read<UserProvider>();

      try {
        if (isReset && userProvider.userCache!.isProfileImageSet) {
          await userProvider.deleteImage();

        } else if (selectedImage != null) {
          final imageBytes = await _resizeImage(selectedImage!, 720);
          await userProvider.updateImage(imageBytes: imageBytes);
        }

        Navigator.of(context).pop();
        SnackBarUtil.showCustomSnackBar(context, '사진이 변경되었습니다.');

      } catch (e) {
        SnackBarUtil.showCommonErrorSnackBar(context);
      }

    } else {
      SnackBarUtil.showCustomSnackBar(context, '사진이 선택되지 않았습니다.');
    }
  }

  Future<Uint8List> _resizeImage(XFile file, int size) async {
    final image = decodeImage(await file.readAsBytes())!;

    final cropSize = image.width < image.height ? image.width : image.height;
    int x = (image.width - cropSize) ~/ 2;
    int y = (image.height - cropSize) ~/ 2;

    final croppedImage = copyCrop(image, x: x, y: y, width: cropSize, height: cropSize);
    final resizedImage = copyResize(croppedImage, width: size, height: size);

    return encodeJpg(resizedImage);
  }

  Future<void> _onNicknameSavePressed(BuildContext context) async {
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
