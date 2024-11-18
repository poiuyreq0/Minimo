import 'package:flutter/material.dart';

class HeartIconComponent extends StatelessWidget {
  const HeartIconComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.favorite,
      color: Colors.red,
      size: 16,
    );
  }
}
