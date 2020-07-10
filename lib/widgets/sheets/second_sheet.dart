import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/providers/notice.dart';
import 'package:new_emfor/screens/notice_detail_screen.dart';
import 'package:new_emfor/widgets/button.dart';

class SecondSheet extends StatefulWidget {
  final noticeId;
  SecondSheet(this.noticeId);
  @override
  _SecondSheetState createState() => _SecondSheetState();
}

class _SecondSheetState extends State<SecondSheet> {
  String text;
  bool loading = true;
  TextEditingController _controller;
  Notice notice;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration()).then((value) async {
      Firestore.instance
          .collection("notices")
          .document(widget.noticeId)
          .get()
          .then((value) {
        notice = Notice(
          id: value.documentID,
          service: value["service"],
          variety: value["variety"],
          description: value["description"] ?? "",
          files: value["files"],
          place: value["place"],
          time: value["time"],
          userPhone: value["userPhone"],
          createdAt: value["createdAt"],
          userName: value["userName"],
          userImage: value["userImage"],
        );
        text = notice.description;
        _controller = TextEditingController(text: notice.description);
        setState(() {
          loading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Zatwierdź zlecenie",
                  style: Theme.of(context).textTheme.headline,
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _controller,
                  maxLines: 5,
                  onChanged: (val) => text = val,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Dodatkowe uwagi",
                    hintText: "Dodatkowe uwagi, które będą podlegały gwarancji",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                FlatButton(
                  child: Text(
                    "Zobacz ogłoszenie",
                    style: Theme.of(context).textTheme.overline,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        NoticeDetailScreen.routeName,
                        arguments: notice);
                  },
                ),
                SizedBox(
                  height: 25 > MediaQuery.of(context).viewInsets.bottom
                      ? 25
                      : MediaQuery.of(context).viewInsets.bottom * 0.8,
                ),
                MyButton(
                  onPressed: () {
                    Firestore.instance
                        .collection("notices")
                        .document(widget.noticeId)
                        .updateData({
                      "description": text,
                    });
                  },
                ),
              ],
            ),
          );
  }
}
