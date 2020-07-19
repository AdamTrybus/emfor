import 'package:flutter/material.dart';

class ShadowSheet extends StatelessWidget {
  final Color color;
  final Widget widget;
  ShadowSheet({this.color = Colors.white, this.widget});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
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
          SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 3,
              width: 80,
              child: Divider(
                thickness: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
