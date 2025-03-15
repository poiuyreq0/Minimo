import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimo/styles/app_style.dart';

class TextFormComponent extends StatelessWidget {
  final String label;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String?>? validator;

  const TextFormComponent({
    required this.label,
    this.hintText,
    this.inputFormatters,
    this.initialValue,
    this.onChanged,
    this.validator,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      maxLength: 10,
      maxLines: 1,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      decoration: AppStyle.getMainInputDecoration(
        context: context,
        label: label,
        hintText: hintText,
      ),
      style: AppStyle.getInputTextStyle(context),
      inputFormatters: inputFormatters,
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
