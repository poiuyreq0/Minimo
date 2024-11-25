import 'package:flutter/material.dart';

class BottomTextFormComponent extends StatelessWidget {
  final VoidCallback onPressed;
  final String hintText;

  const BottomTextFormComponent({
    required this.hintText,
    required this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 200,
      ),
      color: Theme.of(context).colorScheme.onPrimary,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 1000,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                  suffixIconColor: Theme.of(context).colorScheme.primary,
                  border: OutlineInputBorder(),
                  hintText: hintText,
                  counterText: '',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: onPressed,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
