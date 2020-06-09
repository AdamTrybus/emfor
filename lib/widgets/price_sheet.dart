import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:new_emfor/providers/notice.dart';
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
  void _submitData() async {
    if (controller.text.isEmpty) {
      setState(() {
        validate = true;
      });
      return;
    }
    final price = double.parse(controller.text);
    if (price <= 0) {
      setState(() {
        validate = true;
      });
      return;
    }
    var prefs = await SharedPreferences.getInstance();
    Notice notice = widget.notice;
    Firestore.instance
        .collection("notices")
        .document(widget.notice.id)
        .updateData({
      "interests": notice.interests.toString().isNotEmpty
          ? {
              ...notice.interests,
              prefs.getString("phone"): controller.text.trim(),
            }
          : {
              prefs.getString("phone"): controller.text.trim(),
            },
    });
    Navigator.of(context).pushReplacementNamed("/");
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
            Text("Wpisz satysfakcjonującą cię cenę",
                style: Theme.of(context).textTheme.subhead),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                    labelText: 'Wycena',
                    errorText:
                        validate ? "Wprowadź kwotę większą od zera" : null),
                keyboardType: TextInputType.number,
                controller: controller,
              ),
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
            SizedBox(
              width: 200,
              child: RaisedButton(
                onPressed: _submitData,
                color: Colors.amber[500],
                elevation: 6,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                  borderSide: BorderSide(width: 1, color: Colors.amber[500]),
                ),
                child: Text(
                  "Zatwierdź",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
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
