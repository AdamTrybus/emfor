import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/providers/notice.dart';
import 'package:new_emfor/providers/read.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PayuChatWidget extends StatefulWidget {
  static const String routeName = "payuchat-widget";
  @override
  _PayuChatWidgetState createState() => _PayuChatWidgetState();
}

class _PayuChatWidgetState extends State<PayuChatWidget> {
  void modifyData(context) {
    var chat = Provider.of<Read>(context, listen: false).chat;
    Firestore.instance
        .collection("notices")
        .document(chat.noticeId)
        .get()
        .then((value) async {
      dynamic notice = value.data;
      var n = Notice(
        id: value.documentID,
        service: notice["service"],
        variety: notice["variety"],
        description: notice["description"] ?? "",
        files: notice["files"],
        place: notice["place"],
        time: notice["time"],
        userUid: notice["userUid"],
        createdAt: notice["createdAt"],
        userName: notice["userName"],
        userImage: notice["userImage"],
        lat: notice["lat"],
        lng: notice["lng"],
      );
      await Firestore.instance
          .collection("chat")
          .document(chat.chatId)
          .updateData({
        "createdAt": DateTime.now().toString(),
        "process": 4,
        "description": n.description,
        "lat": n.lat,
        "lng": n.lng,
        "place": n.place,
        "variety": n.variety,
        "files": n.files,
        "cancel": false,
      });
      Firestore.instance
          .collection("notices")
          .document(value.documentID)
          .delete();
      Firestore.instance
          .collection("chat")
          .where("noticeId", isEqualTo: value.documentID)
          .where("process", isLessThan: 4)
          .getDocuments()
          .then((value) {
        for (DocumentSnapshot doc in value.documents) {
          doc.reference.delete();
        }
      });
    });
  }

  void onCompleted(context, msg) async {
    final ProgressDialog pr = ProgressDialog(context);
    print("msg $msg");
    print("data ${msg["data"]}");
    if (msg["data"]["status"] != "COMPLETED") {
      Toast.show("Transakcja anulowana", context, duration: 6);
      return;
    }
    pr.style(
        message:
            "Transakcja zaakceptowana, twój czat jest teraz przenoszony do zakładki Zatwierdzone Ogłoszenia");
    await pr.show();
    modifyData(context);
    final prefs = await SharedPreferences.getInstance();
    final fbm = FirebaseMessaging();
    var uid = prefs.getString("uid");
    fbm.unsubscribeFromTopic(uid);
    await pr.hide();
    Navigator.of(context)
        .pushNamedAndRemoveUntil("/", (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.configure(onMessage: (msg) {
      onCompleted(context, msg);
    }, onLaunch: (msg) {
      onCompleted(context, msg);
    }, onResume: (msg) {
      onCompleted(context, msg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: ModalRoute.of(context).settings.arguments,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
