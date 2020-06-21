import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:new_emfor/providers/notice.dart';
import 'package:new_emfor/widgets/button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PriceSheet extends StatefulWidget {
  Notice notice;
  PriceSheet(this.notice);

  @override
  _PriceSheetState createState() => _PriceSheetState();
}

class _PriceSheetState extends State<PriceSheet> with TickerProviderStateMixin {
  var controller = TextEditingController();
  bool validate = false;
  bool negotiate = false;

  void _submitData() async {
    if (controller.text.isEmpty && !negotiate) {
      setState(() {
        validate = true;
      });
      return;
    }
    var price;
    if (!negotiate) {
      if (double.parse(controller.text) <= 0) {
        setState(() {
          validate = true;
        });
        return;
      }
      price = "${controller.text}zł";
    } else {
      price = "--/--";
    }
    var prefs = await SharedPreferences.getInstance();
    Notice notice = widget.notice;
    Firestore.instance
        .collection("notices")
        .document(notice.id)
        .collection("eagers")
        .document(prefs.getString("phone"))
        .setData({
      "expertImage": prefs.getString("image"),
      "expertName": prefs.getString("name"),
      "estimate": price,
      "noticeTitle": notice.service,
      "noticeId": notice.id,
      "expertPhone": prefs.getString("phone"),
      "principal": notice.userPhone,
      "createdAt": notice.createdAt,
    });
    Navigator.of(context).pushReplacementNamed("/");
  }

  Widget radioButton({
    @required bool value,
  }) {
    return Radio(
      value: value,
      activeColor: Colors.black,
      groupValue: negotiate,
      onChanged: (d) {
        setState(() {
          negotiate = d;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                radioButton(value: false),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                    child: TextField(
                      enabled: !negotiate,
                      maxLength: 4,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12.0),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: "Wycena",
                          suffixText: "zł",
                          errorText: validate
                              ? "Wprowadź kwotę większą od zera"
                              : null),
                      keyboardType: TextInputType.number,
                      controller: controller,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                radioButton(value: true),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                    child: Text(
                      "Cena do ustalenia",
                      style: Theme.of(context).textTheme.subhead,
                    ),
                  ),
                )
              ],
            ),
            AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 100),
              curve: Curves.fastOutSlowIn,
              child: SizedBox(
                height: 25 > MediaQuery.of(context).viewInsets.bottom
                    ? 25
                    : MediaQuery.of(context).viewInsets.bottom,
              ),
            ),
            MyButton(
              onPressed: _submitData,
              text: "Zatwierdź",
            ),
            SizedBox(
              height: 6,
            )
          ],
        ),
      ),
    );
  }
}
