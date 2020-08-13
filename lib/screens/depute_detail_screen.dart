import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:new_emfor/providers/depute.dart';
import 'package:new_emfor/providers/deputes.dart';
import 'package:new_emfor/providers/read.dart';
import 'package:new_emfor/screens/support_screen.dart';
import 'package:new_emfor/widgets/chat/message_bubble.dart';
import 'package:new_emfor/widgets/chat/new_message.dart';
import 'package:new_emfor/widgets/depute/depute_info.dart';
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
  String phone, name;
  bool isLoading = true, isExpert;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 0)).then((value) async {
      var prefs = await SharedPreferences.getInstance();
      phone = prefs.getString("phone");
      isExpert = phone == depute.expertPhone;
      name = isExpert ? depute.principalName : depute.expertName;
      Provider.of<Read>(context, listen: false)
          .setVal(depute.chatId, phone == depute.expertPhone);
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
    depute = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          isLoading ? "" : name,
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => _onWillPop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () =>
                Navigator.of(context).pushNamed(SupportScreen.routeName),
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
                  .document(depute.chatId)
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
                  expertPhone: e["expertPhone"],
                  principalPhone: e["principalPhone"],
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
                );
                Provider.of<Deputes>(context, listen: false).setVal(depute,
                    deputeSnapshot.data["side"] == phone, phone, isExpert);
                if (depute.process == 6 &&
                    deputeSnapshot.data["side"] == phone) {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => showDialog(
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
                          }));
                }
                if (depute.process == 7 &&
                    deputeSnapshot.data["side"] == phone) {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              elevation: 4,
                              content: Text(
                                "Zmiana oferty została zaakceptowana",
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
                          }));
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
                        if (depute.estimate != "5") DeputeInfo(),
                        Expanded(
                          child: ListView.builder(
                            reverse: true,
                            itemCount: chatDocs.length,
                            itemBuilder: (ctx, index) => MessageBubble(
                              chatDocs[index]["file"],
                              chatDocs[index]["text"],
                              chatDocs[index]["userPhone"] == phone,
                            ),
                          ),
                        ),
                        NewMessage(depute.chatId, phone),
                      ],
                    );
                  },
                );
              }),
    );
  }
}
