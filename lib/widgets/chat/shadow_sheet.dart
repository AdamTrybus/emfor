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
            color: Colors.grey[350],
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Gwarancja usługi",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              GestureDetector(
                  child: Icon(Provider.of<Read>(context).expanded
                      ? Icons.expand_less
                      : Icons.expand_more),
                  onTap: () =>
                      Provider.of<Read>(context, listen: false).setExpanded()),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          widget,
          SizedBox(
            height: 6,
          ),
        ],
      ),
    );
  }
}
