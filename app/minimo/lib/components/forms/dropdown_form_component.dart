import 'package:flutter/material.dart';
import 'package:minimo/enums/gender.dart';
import 'package:minimo/enums/letter_option.dart';
import 'package:minimo/styles/app_style.dart';

class DropdownFormComponent<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final ValueChanged? onChanged;
  final FormFieldSetter<T?>? onSaved;
  final FormFieldValidator<T?>? validator;

  const DropdownFormComponent({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.onSaved,
    this.validator,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: AppStyle.getMainInputDecoration(
          context: context,
          label: label,
      ),
      value: value,
      items: items.map<DropdownMenuItem<T>>((T value) {
        String item = enumToString(value);
        return DropdownMenuItem(
          value: value,
          child: Text(
            item,
            style: AppStyle.getInputTextStyle(context),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,
    );
  }

  String enumToString(T value) {
    String? res;

    if (value is LetterOption) {
      switch (value.name) {
        case 'ALL':
          res = '짝사랑';
          break;
        case 'NAME':
          res = '이름';
          break;
        case 'MBTI':
          res = 'MBTI';
          break;
        case 'GENDER':
          res = '성별';
          break;
        case 'NONE':
          res = '아무나';
          break;
        default:
          break;
      }
    } else if (value is Gender) {
      switch (value.name) {
        case 'MALE':
          res = '남성';
          break;
        case 'FEMALE':
          res = '여성';
          break;
        default:
          break;
      }
    }

    if (res == null || res.isEmpty) {
      res = value.toString().split('.').last;
    }

    return res;
  }
}