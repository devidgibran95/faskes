import 'package:faskes/pages/utils/styles.dart';
import 'package:flutter/material.dart';

class LabelSection extends StatelessWidget {
  final String text;
  final TextStyle style;
  // create on tap callback

  const LabelSection({required this.text, required this.style, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: style,
        ),
        const Icon(
          Icons.more_horiz,
          color: Colors.blue,
          size: 28,
        ),
      ],
    );
  }
}
