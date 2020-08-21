import 'dart:math';

import 'package:intl/intl.dart';
import 'package:new_emfor/providers/depute.dart';

import '../../screens/depute_detail_screen.dart';
import 'package:flutter/material.dart';

class DeputeItem extends StatelessWidget {
  final Depute depute;
  final bool isExpert;
  DeputeItem(this.depute, this.isExpert);

  bool read() {
    if (isExpert) {
      return !depute.expertRead;
    } else {
      return !depute.principalRead;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              depute.noticeTitle,
              style: TextStyle(
                fontFamily: "Quicksand",
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: !depute.cancel
                      ? Text(
                          DateFormat("dd/MM/yyyy HH:mm")
                              .format(DateTime.parse(depute.createdAt)),
                          style: Theme.of(context).textTheme.overline,
                        )
                      : Text(
                          "Odwołano",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                            fontFamily: "Gotham",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              DeputeDetailScreen.routeName,
                              arguments: depute);
                        },
                        child: Text(
                          "Czat",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        color: Colors.black,
                      ),
                    ),
                    read()
                        ? Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.amber[800],
                              ),
                              constraints: BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
