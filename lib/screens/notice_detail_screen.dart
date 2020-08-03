import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/chat.dart';
import '../providers/read.dart';
import '../screens/chat_detail_screen.dart';
import '../widgets/list_item.dart';
import '../widgets/notice_detail_builder.dart';
import 'package:provider/provider.dart';
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
                        .document("${notice.id}-${prefs.getString("phone")}")
                        .setData({
                      "expertImage": prefs.getString("image"),
                      "expertName": prefs.getString("name"),
                      "noticeTitle": notice.service,
                      "noticeId": notice.id,
                      "expertPhone": prefs.getString("phone"),
                      "principalPhone": notice.userPhone,
                      "createdAt": notice.createdAt,
                      "expertRead": true,
                      "principalImage": notice.userImage,
                      "principalName": notice.userName,
                      "principalRead": false,
                      "process": 0,
                    });
                    Chat chat = Chat(
                      chatId: "${notice.id}-${prefs.getString("phone")}",
                      expertImage: prefs.getString("image"),
                      expertName: prefs.getString("name"),
                      noticeTitle: notice.service,
                      noticeId: notice.id,
                      expertPhone: prefs.getString("phone"),
                      principalPhone: notice.userPhone,
                      createdAt: notice.createdAt,
                      expertRead: true,
                      principalImage: notice.userImage,
                      principalName: notice.userName,
                      principalRead: false,
                      process: 0,
                    );
                    Provider.of<Read>(context, listen: false).setValues(
                      chat: chat,
                      isExpert: true,
                    );
                    Navigator.of(context).pushNamed(ChatScreenDetail.routeName);
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
