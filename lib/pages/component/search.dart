import 'package:faskes/pages/utils/styles.dart';
import 'package:flutter/material.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            cursorColor: ancent,
            style: p1,
            autocorrect: false,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, size: 22, color: text),
              hintText: 'Cari faskes terdekat',
              hintStyle: p1,
              fillColor: white,
              contentPadding: EdgeInsets.symmetric(vertical: small),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(width: small),
        Container(
          decoration: BoxDecoration(
              color: ancent, borderRadius: BorderRadius.circular(12)),
          height: 50,
          width: 50,
          child: Icon(
            Icons.cable,
            color: white,
          ),
        ),
      ],
    );
  }
}
