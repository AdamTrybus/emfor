import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String baseText,infoText;
  final bool divider;
  ListItem({
    @required this.baseText,
    @required this.infoText,
    this.divider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "$baseText:",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(
        width: 2,
      ),
      Text(
        "$infoText",
        style: TextStyle(
          fontFamily: "Quicksand",
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        softWrap: true,
      ),
      SizedBox(
        height: 12,
        child: Divider(
          color: divider ? Colors.black38 : Colors.transparent,
          endIndent: 8,
          indent: 8,
          height: 2,
        ),
      )
    ]);
  }
}
