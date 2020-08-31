import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:new_emfor/providers/deputes.dart';
import 'package:new_emfor/providers/notice.dart';
import 'package:new_emfor/providers/read.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PayuDeputeWidget extends StatefulWidget {
  static const String routeName = "payuDepute-widget";
  @override
  _PayuDeputeWidgetState createState() => _PayuDeputeWidgetState();
}

class _PayuDeputeWidgetState extends State<PayuDeputeWidget> {
  void modifyData() async {
    var depute = Provider.of<Deputes>(context, listen: false).chosenDepute;
    var result = await Firestore.instance
        .collection("chat")
        .document(depute.chatId)
        .get();
    var estimate = result.data["new_estimate"];
    var attentions = result.data["new_attentions"];
    var day = result.data["new_meet"];
    var list = new List.from(depute.activity);
    list.add({
      "choice": 2,
      "data": DateTime.now().toString(),
    });
    var map = {
      "process": 5,
      "estimate": estimate,
      "attentions": attentions,
      "meet": day,
      "activity": list
    };
    Firestore.instance
        .collection("chat")
        .document(depute.chatId)
        .updateData(map);
  }

  void onCompleted(msg) async {
    final ProgressDialog pr = ProgressDialog(context);
    print("msg $msg");
    print("data ${msg["data"]}");
    if (msg["data"]["status"] != "COMPLETED") {
      Toast.show("Transakcja anulowana", context, duration: 6);
      return;
    }
    pr.style(message: "Transakcja zaakceptowana");
    await pr.show();
    modifyData();
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
      onCompleted(msg);
    }, onLaunch: (msg) {
      onCompleted(msg);
    }, onResume: (msg) {
      onCompleted(msg);
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
