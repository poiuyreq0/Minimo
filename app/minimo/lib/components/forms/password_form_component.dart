import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimo/styles/app_style.dart';

class PasswordFormComponent extends StatefulWidget {
  final String label;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String?>? validator;

  const PasswordFormComponent({
    required this.label,
    this.hintText,
    this.inputFormatters,
    this.onChanged,
    this.validator,
    super.key
  });

  @override
  State<PasswordFormComponent> createState() => _PasswordFormComponentState();
}

class _PasswordFormComponentState extends State<PasswordFormComponent> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      maxLines: 1,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      obscureText: isObscure,
      decoration: AppStyle.getMainInputDecoration(
        context: context,
        label: widget.label,
        hintText: widget.hintText,
        suffixIcon: IconButton(
          icon: Icon(
            isObscure ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              isObscure = !isObscure;
            });
          },
        ),
      ),
      style: AppStyle.getInputTextStyle(context),
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      validator: widget.validator,
    );
  }
}
