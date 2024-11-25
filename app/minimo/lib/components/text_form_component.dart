import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormComponent extends StatefulWidget {
  final String label;
  final String? hintText;
  final bool isContent;
  final bool isPassword;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final FormFieldSetter<String?>? onSaved;
  final FormFieldValidator<String?>? validator;

  const TextFormComponent({
    required this.label,
    this.hintText,
    this.isContent = false,
    this.isPassword = false,
    this.inputFormatters,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onTap,
    this.onSaved,
    this.validator,
    super.key
  });

  @override
  State<TextFormComponent> createState() => _TextFormComponentState();
}

class _TextFormComponentState extends State<TextFormComponent> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.isContent ? TextInputType.multiline : TextInputType.text,
      maxLength: widget.isContent ? 1000 : (widget.isPassword ? null : 20),
      maxLines: widget.isContent ? null : 1,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      minLines: widget.isContent ? 10 : null,
      obscureText: widget.isPassword ? isObscure : false,
      decoration: InputDecoration(
        label: Text(
          widget.label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: 14,
        ),
        counterText: widget.isContent? null : '',
        contentPadding: const EdgeInsets.only(top: 8),
        suffixIcon: widget.isPassword ? IconButton(
          icon: Icon(
            isObscure ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              isObscure = !isObscure;
            });
          },
        ) : null,
      ),
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
        fontSize: 16,
      ),
      inputFormatters: widget.inputFormatters,
      controller: widget.controller,
      initialValue: widget.initialValue,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onSaved: widget.onSaved,
      validator: widget.validator,
    );
  }
}
