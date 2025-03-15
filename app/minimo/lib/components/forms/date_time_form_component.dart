import 'package:flutter/material.dart';
import 'package:minimo/styles/app_style.dart';

class DateTimeFormComponent extends StatelessWidget {
  final String label;
  final String? hintText;
  final DateTime? initialDate;
  final TextEditingController controller;
  final GestureTapCallback onTap;
  final FormFieldValidator<String?>? validator;

  const DateTimeFormComponent({
    required this.label,
    this.hintText,
    this.initialDate,
    required this.controller,
    required this.onTap,
    this.validator,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          maxLines: 1,
          decoration: AppStyle.getMainInputDecoration(
            context: context,
            label: label,
            hintText: hintText,
          ),
          style: AppStyle.getInputTextStyle(context),
          controller: controller,
          validator: validator,
        ),
      ),
    );
  }
}
