import 'package:flutter/material.dart';
import 'package:minimo/consts/gender.dart';
import 'package:minimo/consts/letter_option.dart';

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
      decoration: InputDecoration(
        label: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        contentPadding: const EdgeInsets.only(top: 8),
      ),
      value: value,
      items: items.map<DropdownMenuItem<T>>((T value) {
        String item = enumToString(value);
        return DropdownMenuItem(
          value: value,
          child: Text(
            item,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontSize: 16,
            ),
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
          res = '이름 초성';
          break;
        case 'MBTI':
          res = 'MBTI';
          break;
        case 'GENDER':
          res = '성별';
          break;
        case 'NONE':
          res = '미지의 누군가';
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