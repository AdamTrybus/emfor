import 'package:flutter/material.dart';
import 'package:new_emfor/widgets/chat/guarantee_window.dart';

class GuaranteeWidget extends StatelessWidget {
  final noticeId;
  GuaranteeWidget(this.noticeId);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Gwarancja usługi",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              "Aby uzyskać gwarancję musisz podać nam jeszcze kilka informacji, takich jak cena czy termin - skonsultowanych z wykonawcą",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Expanded(child: SizedBox()),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(GuaranteeWindow.routeName,
                        arguments: noticeId);
                  },
                  child: Text(
                    "Uzyskaj gwarancje",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.amber[600]),
                  ),
                ),
              ],
            ),
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
        ));
  }
}
