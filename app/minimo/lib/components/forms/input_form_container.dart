import 'package:flutter/material.dart';
import 'package:minimo/styles/app_style.dart';

class InputFormContainer extends StatelessWidget {
  final List<Widget> children;

  const InputFormContainer({
    required this.children,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
      alignment: Alignment.center,
      decoration: AppStyle.getMainBoxDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}