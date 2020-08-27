import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/chat_detail_screen.dart';
import '../widgets/list_item.dart';
import '../widgets/notice_detail_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/notice.dart';
import 'package:flutter/material.dart';

class NoticeDetailScreen extends StatelessWidget {
  static const routeName = '/notice_detail-screen';
  Notice notice;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    notice = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          InfoDetailBuilder(notice: notice, height: height),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: ListItem(
                      baseText: "Zleceniodawca",
                      divider: false,
                      infoText: notice.userName),
                ),
                RaisedButton(
                  color: Colors.black,
                  onPressed: () async {
                    var prefs = await SharedPreferences.getInstance();
                    Firestore.instance
                        .collection("chat")
                        .document("${notice.id}-${prefs.getString("uid")}")
                        .setData({
                      "expertImage": prefs.getString("image"),
                      "expertName": prefs.getString("name"),
                      "noticeTitle": notice.service,
                      "noticeId": notice.id,
                      "expertUid": prefs.getString("uid"),
                      "principalUid": notice.userUid,
                      "createdAt": notice.createdAt,
                      "expertRead": true,
                      "principalImage": notice.userImage,
                      "principalName": notice.userName,
                      "principalRead": false,
                      "process": 0,
                    });
                    Navigator.of(context).pushNamed(ChatScreenDetail.routeName,
                        arguments: "${notice.id}-${prefs.getString("uid")}");
                  },
                  child: Text(
                    "Czat",
                    style: TextStyle(color: Colors.white, fontFamily: "Lato"),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
