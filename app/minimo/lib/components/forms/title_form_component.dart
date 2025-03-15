import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimo/styles/app_style.dart';

class TitleFormComponent extends StatelessWidget {
  final String label;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String?>? validator;

  const TitleFormComponent({
    required this.label,
    this.hintText,
    this.onChanged,
    this.validator,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      maxLines: null,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      decoration: AppStyle.getMainInputDecoration(
        context: context,
        label: label,
        hintText: hintText,
      ),
      style: AppStyle.getInputTextStyle(context),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
