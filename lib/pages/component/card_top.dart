import 'package:faskes/pages/utils/styles.dart';
import 'package:flutter/material.dart';

class CardTop extends StatelessWidget {
  final String name;
  final String image;
  final String indo;

  const CardTop(
      {required this.name, required this.image, required this.indo, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: white, borderRadius: BorderRadius.circular(20)),
      height: 75,
      width: 170,
      margin: const EdgeInsets.only(right: 15),
      child: Row(
        children: [
          SizedBox(width: 0),
          Container(
            decoration: BoxDecoration(
                color: ancent,
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage(image),
                )),
            height: 69,
            width: 69,
          ),
          SizedBox(width: xsmall),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name, style: heading4),
              Text(indo, style: p3),
            ],
          )
        ],
      ),
    );
  }
}
