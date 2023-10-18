import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class TileItem extends StatefulWidget {
  var item;
  TileItem({required this.item, super.key});

  @override
  State<TileItem> createState() => _TileItemState();
}

class _TileItemState extends State<TileItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: GFListTile(
      titleText: widget.item.name,
      subTitleText: widget.item.desc,
    ));
  }
}
