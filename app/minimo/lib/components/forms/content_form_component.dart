import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimo/styles/app_style.dart';

class ContentFormComponent extends StatelessWidget {
  final String label;
  final String? hintText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String?>? validator;

  const ContentFormComponent({
    required this.label,
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.validator,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLength: 1000,
      maxLines: null,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      minLines: 10,
      decoration: AppStyle.getMainInputDecoration(
        context: context,
        label: label,
        hintText: hintText,
        counterText: null,
      ),
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
        fontSize: 16,
      ),
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
    );
  }
}