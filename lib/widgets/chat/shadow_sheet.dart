import 'package:flutter/material.dart';
import 'package:new_emfor/providers/read.dart';
import 'package:provider/provider.dart';

class ShadowSheet extends StatelessWidget {
  final Color color;
  final Widget widget;
  ShadowSheet({this.color = Colors.white, this.widget});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[500],
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          widget,
          FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () =>
                Provider.of<Read>(context, listen: false).setExpanded(),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 80,
                child: Divider(
                  thickness: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
