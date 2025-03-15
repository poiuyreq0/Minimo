import 'package:flutter/material.dart';

class BottomTextFormComponent extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;

  const BottomTextFormComponent({
    required this.hintText,
    required this.controller,
    required this.onPressed,
    this.focusNode,
    super.key
  });

  @override
  State<BottomTextFormComponent> createState() => _BottomTextFormComponentState();
}

class _BottomTextFormComponentState extends State<BottomTextFormComponent> {
  bool isShowIconButton = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(textChangeListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(textChangeListener);
    super.dispose();
  }

  void textChangeListener() {
    setState(() {
      if (widget.controller.text.isEmpty) {
        isShowIconButton = false;
      } else {
        isShowIconButton = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 200,
      ),
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                focusNode: widget.focusNode,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 1000,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onPrimary,
                  suffixIconColor: Theme.of(context).colorScheme.primary,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      width: 3.0,
                    ),
                  ),
                  hintText: widget.hintText,
                  counterText: '',
                  suffixIcon: isShowIconButton ? IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: widget.onPressed,
                  ) : null,
                ),
                controller: widget.controller,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
