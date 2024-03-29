import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:new_emfor/providers/depute.dart';
import 'package:new_emfor/providers/deputes.dart';
import 'package:new_emfor/providers/read.dart';
import 'package:new_emfor/screens/profile_screen.dart';
import 'package:new_emfor/screens/support_screen.dart';
import 'package:new_emfor/widgets/chat/message_bubble.dart';
import 'package:new_emfor/widgets/chat/new_message.dart';
import 'package:new_emfor/widgets/depute/depute_drawer.dart';
import 'package:new_emfor/widgets/depute/depute_info.dart';
import 'package:new_emfor/widgets/depute/payu_depute_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class DeputeDetailScreen extends StatefulWidget {
  static const String routeName = "mynoticedetail_screen";

  @override
  _DeputeDetailScreenState createState() => _DeputeDetailScreenState();
}

class _DeputeDetailScreenState extends State<DeputeDetailScreen> {
  Depute depute;
  String uid, name = "", deputeId;
  bool isLoading = true, isExpert = true, supportRead = true, cancel = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) async {
      deputeId = ModalRoute.of(context).settings.arguments;
      var prefs = await SharedPreferences.getInstance();
      uid = prefs.getString("uid");
      var pushUp = prefs.getBool("pushUp") ?? true;
      if (pushUp) {
        final fbm = FirebaseMessaging();
        fbm.subscribeToTopic(deputeId);
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  void _onWillPop() async {
    Provider.of<Read>(context, listen: false).setRead();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: DeputeDrawer(),
      resizeToAvoidBottomPadding: true,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: FlatButton(
          onPressed: isExpert
              ? null
              : () => Navigator.of(context)
                  .pushNamed(ProfileScreen.routeName, arguments: uid),
          child: Text(
            name,
            style: TextStyle(color: Colors.black),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => _onWillPop(),
        ),
        actions: [
          Stack(children: [
            IconButton(
              icon: Icon(Icons.flag),
              onPressed: () => Navigator.of(context)
                  .pushNamed(SupportScreen.routeName, arguments: {
                "supportId": deputeId,
                "problem": depute.problem
              }),
            ),
            !supportRead
                ? Positioned(
                    right: 6.5,
                    top: 6.5,
                    child: Container(
                      padding: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber[800],
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                    ),
                  )
                : SizedBox(),
          ]),
          if (!cancel)
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
            )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder(
              stream: Firestore.instance
                  .collection("chat")
                  .document(deputeId)
                  .snapshots(),
              builder: (ctx, deputeSnapshot) {
                if (deputeSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var e = deputeSnapshot.data;
                depute = Depute(
                  chatId: e.documentID,
                  expertImage: e["expertImage"],
                  expertName: e["expertName"],
                  noticeTitle: e["noticeTitle"],
                  noticeId: e["noticeId"],
                  expertUid: e["expertUid"],
                  principalUid: e["principalUid"],
                  createdAt: e["createdAt"],
                  expertRead: e["expertRead"],
                  principalImage: e["principalImage"],
                  principalName: e["principalName"],
                  principalRead: e["principalRead"],
                  process: e["process"],
                  attentions: e["attentions"],
                  estimate: e["estimate"],
                  meet: e["meet"],
                  description: e["description"],
                  files: e["files"],
                  lat: e["lat"],
                  lng: e["lng"],
                  place: e["place"],
                  variety: e["variety"],
                  cancel: e["cancel"],
                  problem: e["problem"] ?? false,
                  activity: e["activity"] ?? [],
                  supportExpertRead: e["supportExpertRead"] ?? true,
                  supportPrincipalRead: e["supportPrincipalRead"] ?? true,
                );
                isExpert = uid == depute.expertUid;
                cancel = depute.cancel;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (name == "") {
                    setState(() {
                      name =
                          isExpert ? depute.principalName : depute.expertName;
                    });
                  }
                });
                Provider.of<Read>(context, listen: false)
                    .setVal(depute.chatId, uid == depute.expertUid);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  var val = isExpert
                      ? depute.supportExpertRead
                      : depute.supportPrincipalRead;
                  if (supportRead != val) {
                    setState(() {
                      supportRead = val;
                    });
                  }
                });
                Provider.of<Deputes>(context, listen: false).setVal(
                    depute, deputeSnapshot.data["side"] == uid, uid, isExpert);
                if (depute.process == 6 && deputeSnapshot.data["side"] == uid) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          elevation: 4,
                          content: Text(
                            "Zmiana oferty została niezaakceptowana",
                            style: Theme.of(context).textTheme.subhead,
                          ),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Firestore.instance
                                      .collection("chat")
                                      .document(depute.chatId)
                                      .updateData({"process": 4});
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Ok",
                                  style: Theme.of(context).textTheme.title,
                                ))
                          ],
                        );
                      },
                    ),
                  );
                }
                return StreamBuilder(
                  stream: Firestore.instance
                      .collection("chat")
                      .document(depute.chatId)
                      .collection("messages")
                      .orderBy("createdAt", descending: true)
                      .snapshots(),
                  builder: (ctx, chatSnapshot) {
                    if (chatSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var chatDocs = chatSnapshot.data.documents ?? [];
                    return Column(
                      children: [
                        DeputeInfo(),
                        Expanded(
                          child: ListView.builder(
                            reverse: true,
                            itemCount: chatDocs.length,
                            itemBuilder: (ctx, index) => MessageBubble(
                              chatDocs[index]["file"],
                              chatDocs[index]["text"],
                              chatDocs[index]["userUid"] == uid,
                            ),
                          ),
                        ),
                        NewMessage(
                            depute.chatId,
                            uid,
                            isExpert ? depute.expertName : depute.principalName,
                            "depute"),
                      ],
                    );
                  },
                );
              }),
    );
  }
}
